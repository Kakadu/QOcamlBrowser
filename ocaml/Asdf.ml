(* Generated at 2012-11-26 15:37:14.233873 *)
type t
external emit_signal_tableCount1: t -> int -> unit =
  "stub_tableCount1_emit_tablesChanged"
external prop_get_tableCount1:    t -> unit -> int =
  "prop_Asdf_tableCount1_get_int"
external prop_set_tableCount1:    t -> int -> unit =
  "prop_Asdf_tableCount1_set_int"
external emit_signal_showDescription: t -> bool -> unit =
  "stub_showDescription_emit_showDescriptionChanged"
external prop_get_showDescription:    t -> unit -> bool =
  "prop_Asdf_showDescription_get_bool"
external prop_set_showDescription:    t -> bool -> unit =
  "prop_Asdf_showDescription_set_bool"
external emit_signal_itemDescription: t -> string -> unit =
  "stub_itemDescription_emit_itemDescriptionChanged"
external prop_get_itemDescription:    t -> unit -> string =
  "prop_Asdf_itemDescription_get_string"
external prop_set_itemDescription:    t -> string -> unit =
  "prop_Asdf_itemDescription_set_string"

class asdf cppval = object
  method emit_tablesChanged = emit_signal_tableCount1 cppval
  method tableCount1 = prop_get_tableCount1 cppval ()
  method set_tableCount1 = prop_set_tableCount1 cppval

  method emit_showDescriptionChanged = emit_signal_showDescription cppval
  method showDescription = prop_get_showDescription cppval ()
  method set_showDescription = prop_set_showDescription cppval

  method emit_itemDescriptionChanged = emit_signal_itemDescription cppval
  method itemDescription = prop_get_itemDescription cppval ()
  method set_setDescription = prop_set_itemDescription cppval

end
