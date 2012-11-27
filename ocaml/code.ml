open Printf
open Types

let (|>) x f = f x
let ocaml_where = "/usr/lib/ocaml"
let (^/) a b = String.concat "" [a;"/";b]
let () = Printexc.record_backtrace true

module List = struct
  include List
  let filter_map (f: 'a -> 'b option) (xs: 'a list) : 'b list =
    fold_right (fun x acc ->
            match f x with
            | Some y -> y::acc
            | None   ->    acc) xs []
  let nth where n =
    if n<0 then raise (Failure "bad argument of nth")
    else nth where n

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
  let take_while cond xs =
    let rec helper acc = function
      | [] -> List.rev acc
      | h::tl when cond h -> helper (h::acc) tl
      | _:: tl  -> helper acc tl
    in
    helper [] xs
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

let setData ooo newData =
  if !data <> newData then begin
    data := [];
    ooo#set_tableCount1 0;
    data:=newData;
    ooo#set_tableCount1 (List.length newData)
  end

let print_data data =
  let s = data |> List.map (fun xs -> String.concat "; " xs)
    |> String.concat "];\n[" in
  printf "[ [ %s ] ]\n%!" s

exception Finished_too_early
exception Finished
let path_changed
  : int list -> string list list * string option =
  with_register "caml_path_changed"
  begin fun ls ->
    printf "new path: %s\n%!" (String.concat "" (List.map (fun i -> "/"^(string_of_int i)) ls));
    (*let ls = List.take_while (fun x -> 0<=x) ls in*)
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
    let new_data = ref (List.take (List.length ls) !data) in
    printf "new_data.length = %d\n%!" (List.length !new_data);
    let () =
      try
       (List.tl ls) |> List.iter_with_tail (fun index tail ->
        let is_last = (0 = List.length tail) in
        let item = List.nth !cur_sig index in
        match item with
        | Types.Tsig_module (ident,Types.Tmty_signature xs,_) when is_last -> begin
            printf "We should add new view for module\n%!";
            action := Some (`NewView xs);
            new_data := List.take (List.length !new_data - (List.length tail)) !new_data;
            printf "New length of data is %d%!" (List.length !new_data);
            raise Finished
          end
        | Types.Tsig_module (ident,_,_) when is_last -> begin
            printf "We should decribe module it below\n%!";
            action := Some (`Describe item);
            (*new_data := List.take (List.length !new_data - (List.length tail)) !new_data; *)
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
          printf "describe something\n%!";
          action := Some (`Describe item);
          assert (List.length !new_data = List.length ls);
          (*new_data := List.take (List.length !new_data - (List.length tail)) !new_data;*)
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
         new_data := !new_data @ [ys];
      | Some (`Describe item) -> begin
           let b = Buffer.create 100 in
           Buffer.add_string b (sprintf "Describing `%s`:\n" "???");
           let fmt = Format.(formatter_of_buffer b) in
           let () = Printtyp.signature fmt [item] in

           descr := Some (Buffer.contents b);
           printf "Describe: %s\n%!" (Buffer.contents b);
        end
    in
    (*print_data ();*)
    (!new_data,!descr)
end

let selected = ref []

let _foo =
  with_register "Asdf_init_unit_unit" begin fun cppobj () ->
    printf "here!\n%!";
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
    data := [List.map fst (List.take 26 modules)];
    let obj = new Asdf.asdf cppobj in
    (*data := [List.map fst (modules)];*)
    print_data !data;
    printf "List.length !data = %d\n%!" (List.length !data);
    obj#set_tableCount1 (List.length !data);
    selected := List.map (fun _ -> -1) !data
  end

let getTableCount : Asdf.t -> unit -> int =
  with_register "prop_Asdf_tableCount1_get_int" begin fun _ () ->
    let ans = List.length !data in
    printf "getTableCount() = %d\n%!" ans;
    ans
end

let showDescriptionFlag = ref false
let canShowDescription : Asdf.t -> unit -> bool =
  with_register "prop_Asdf_showDescription_get_bool" begin fun _ () ->
  !showDescriptionFlag
end

let setCanShowDescriptionFlag ooo newVal =
  if !showDescriptionFlag <> newVal then (
    showDescriptionFlag := newVal;
    ooo#emit_showDescription newVal;
  )

let tableLength : Asdf.t -> int -> int =
  with_register "Asdf_tableLength_int_int" begin fun _ x ->
  (*printf "Get length of table %d\n%!" x;*)
  List.nth !data x |> List.length
end

let take : Asdf.t -> int -> int -> string =
  with_register "Asdf_take_string_int_int" begin fun _ x y ->
  List.nth (List.nth !data x) y
end
(*
let selectedIndexes = ref [| |]
let description = ref ""

let () =  (* initialization*)
  let _ = init_data () in
  selectedIndexes := Array.of_list (List.map (fun _ -> -1) !data);
  description := "";
  showDescriptionFlag := false
*)
(*
let doOCaml ooo lastAffectedColumn =
  let (new_data,descr) = path_changed (Array.to_list !selectedIndexes) in
  setData ooo new_data;

  match descr with
  | Some d ->
      setCanShowDescriptionFlag ooo true;
      setDescription ooo d;
  | None -> showDescriptionFlag := false
;;
*)

let setSelectedIndexAt : Asdf.t -> int -> int -> bool =
  with_register "Asdf_setSelectedIndexAt_unit_int_int" begin
  fun obj column newv ->
    printf "setSelectedIndexAt %d to %d\n%!" column newv;(*
    printf "selectedIndexes.length = %d\n" (List.length !selected);*)
    assert (List.length !selected > column);
    assert (column >=0);
    if List.nth !selected column <> newv then (
      let ooo = new Asdf.asdf obj in

      let new_indexes =
        let prefix = if column=0 then[] else List.take column !selected in
        prefix@[newv]
      in
      selected := new_indexes;
      (*printf "List.length new_indexes = %d\n%!" (List.length new_indexes);*)
      assert (List.length !selected = column+1);
      let (new_data,descr) = path_changed !selected in
      if List.length new_data > List.length !selected then
        selected:= !selected @ [-1];
      setData ooo new_data;

      let () =match descr with
      | Some d ->
          ooo#set_setDescription d;
          ooo#set_showDescription true;

      | None ->
          ooo#set_showDescription false
      in

      print_data !data;(*
      printf "selected: [%s]\n%!" (!selected
        |> List.map string_of_int |> String.concat "; "); *)
      true
    ) else false
end


