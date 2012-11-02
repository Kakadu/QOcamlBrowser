open Printf
open Types

let (|>) x f = f x
let ocaml_where = "/usr/lib/ocaml"
let (^/) a b = String.concat "" [a;"/";b]

module List = struct
  include List
  let filter_map (f: 'a -> 'b option) (xs: 'a list) : 'b list =
    fold_right (fun x acc ->
            match f x with
            | Some y -> y::acc
            | None   ->    acc) xs []
  let rec take ?(acc=[]) n xs =
    match xs with
    | _ when n = 0 -> rev acc
    | h::tl -> take ~acc:(h::acc) (n-1) tl
    | [] -> raise (Failure "List.take")
  let rec iter_with_tail f = function
    | [] -> ()
    | h :: tl -> f h tl; iter_with_tail f tl
  let zip_non_exn xs ys =
    let rec helper acc (xs,ys) =
      match (xs,ys) with
      | (h1::t1,h2::t2) -> helper (fun l -> (h1,h2) :: (acc l)) (t1,t2)
      | ([],_)
      | (_,[]) -> acc
    in
    helper (fun _ -> []) (xs,ys) [] |> List.rev

end

let modulename_of_file filename =
  let ans = String.copy filename in
  ans.[0] <- Char.uppercase ans.[0];
  ans

let files_in_dir path =
  let d = Unix.opendir path in
  let ans = ref [] in
  try
    while true do ans := (Unix.readdir d) :: !ans done;
    assert false
  with
    End_of_file -> Unix.closedir d; !ans

let gamemap = object
  val mutable title = "mytitle"
  method title () = title
  method setTitle s = title <- s
  val mutable width = 640
  method width () = width
  method setWidth s = width <- s

end

let () = Callback.register "prop_Gamemap_title_get_string" gamemap#title
let () = Callback.register "prop_Gamemap_title_set_string" gamemap#setTitle

let () = Callback.register "prop_Gamemap_width_get_int" gamemap#width
let () = Callback.register "prop_Gamemap_width_set_int" gamemap#setWidth

let with_register s f =
  Callback.register s f;
  f

(* Stolen from typing/env.ml *)
let process_cmi_file filename : Types.signature =
  let ic = open_in_bin filename in
  let magic_len = String.length (Config.cmi_magic_number) in
  let buffer = String.create magic_len in
  really_input ic buffer 0 magic_len ;
  let (name, sign) = input_value ic in
  close_in ic;
  sign

let readdata = with_register "caml_readdata"  begin
  fun () ->
    let lst = files_in_dir "." in
    let cmis = List.filter (fun s -> Filename.check_suffix s ".cmi") lst in
    let moduleNames = List.map (fun s ->
      let s2 = String.copy s in
      s2.[0] <- Char.uppercase s2.[0];
      s2) (List.map Filename.basename cmis) in
    moduleNames
end

let get_ident_of_signature = function
| Tsig_value     (ident,_) -> ident
| Tsig_type    (ident,_,_) -> ident
| Tsig_exception (ident,_) -> ident
| Tsig_module (ident,_,_)  -> ident
| Tsig_modtype(ident,_)    -> ident
| Tsig_class  (ident,_,_)  -> ident
| Tsig_cltype (ident,_,_)  -> ident

let sigs_in_module = function
| Tsig_module (_,Types.Tmty_signature xs,_) -> xs
| _ -> raise (Failure "")

let modules_cache = ref []
let data = ref []

exception Finished_too_early
exception Finished
let path_changed
  : int list -> string list list * string option =
  with_register "caml_path_changed" begin fun ls ->
    printf "new path: %s\n%!" (String.concat "" (List.map (fun i -> "/"^(string_of_int i)) ls));
    List.iter (fun i -> assert (i>=0)) ls;
    let moduleName = List.nth (List.hd !data) (List.hd ls) in
    let signature = List.assoc moduleName !modules_cache in
    let cur_sig = match signature with
      | Types.Tsig_module (_,Types.Tmty_signature xs,_) -> ref xs
      | _ -> assert false
    in
    let action = ref (Some (
      `NewView (signature |> sigs_in_module)
    ) ) in
    data := List.take (List.length ls) !data;
    let () = try
      (List.tl ls) |> List.iter_with_tail (fun index tail ->
        let is_last = (0 = List.length tail) in
        let item = List.nth !cur_sig index in
        match item with
        | Types.Tsig_module (ident,Types.Tmty_signature xs,_) when is_last -> begin
            printf "We should add new view for module%!";
            action := Some (`NewView xs);
            data := List.take (List.length !data - (List.length tail)) !data;
            printf "New length of data is %d%!" (List.length !data);
            raise Finished
          end
        | Types.Tsig_module (ident,_,_) when is_last -> begin
            print_endline "We should decribe it below";
            action := Some (`Describe item);
            data := List.take (List.length !data - (List.length tail)) !data;
            raise Finished
          end
        | Types.Tsig_module (ident,Types.Tmty_signature xs,_) -> begin
            (* go iterate next *) cur_sig := xs;
          end
        | Types.Tsig_module (ident,_,_) -> begin
            raise (Failure "Bad iteration")
          end
        | _ when not is_last -> begin
            raise (Failure "Bad iteration")
          end
        (* below will be matched non-module signatures in last position*)
        | _ -> begin
          print_endline "describe something";
          action := Some (`Describe item);
          data := List.take (List.length !data - (List.length tail)) !data;
          raise Finished
        end
      )
    with Finished -> ()
    in
    let descr = ref None in
    let () = match !action with
      | None -> assert false
      | Some (`NewView xs) ->
         let ys = List.map (fun s -> s |> get_ident_of_signature |> Ident.name) xs in
         data := !data @ [ys]
      | Some (`Describe item) -> begin
           let info ident =
             descr := Some (sprintf "describing item `%s`%!" (Ident.name ident)) in
           match item with
           | Tsig_value     (ident,_) -> info ident
           | Tsig_type    (ident,_,_) -> info ident
           | Tsig_exception (ident,_) -> info ident
           | Tsig_module (_,Types.Tmty_signature _,_)  -> assert false
           | Tsig_module (ident,_,_)  -> info ident
           | Tsig_modtype(ident,_)    -> info ident
           | Tsig_class  (ident,_,_)  -> info ident
           | Tsig_cltype (ident,_,_)  -> info ident
        end
      in
      (*!data,None*)
      (!data,!descr)
end

let init_data : unit -> string list list =
  with_register "caml_init_data" begin fun () ->
    let filenames = files_in_dir ocaml_where
      |> List.filter (fun s -> Filename.check_suffix s ".cmi") in
    let modules = filenames |> List.filter_map (fun filename ->
      let sign = process_cmi_file (ocaml_where ^/ filename) in
      let basename = Filename.chop_suffix filename ".cmi" in
      let moduleName = modulename_of_file basename in
      Some (moduleName, sign)
    ) in
    modules_cache := modules |> List.map (fun (name,s) ->
      (name, Tsig_module (Ident.create name, Types.Tmty_signature s, Types.Trec_not))
    );
    (*data := [List.map fst (List.take 20 modules)];*)
    data := [List.map fst (modules)];
    !data
  end
