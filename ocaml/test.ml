open Code
open Printf
open Format

let () =
  let lst = readdata() in
  List.iter print_endline lst

let print_sig sign =
  fprintf std_formatter "@[Signature@ =@ @[<1>%a@]@]@."
    Printtyp.signature
    sign
(*
open Types
let _ =
  List.iter (function
  | Tsig_valie
  ) (process_cmi_file "code.cmi")
*)

let () =
  let xs = init_data () in
  let f = fun ys -> sprintf "[%s]" (String.concat ";" ys) in
  xs |> List.map f |> (fun ys -> sprintf "[%s]" (String.concat ";" ys)) |> print_endline
