/*
 * Generated at 2012-11-26 15:37:14.228264
 */
#include "Asdf.h"

extern "C" value stub_tableCount1_emit_tablesChanged(value _obj, value _arg) {
  CAMLparam2(_obj,_arg);
  Asdf *cppobj = (Asdf*) (Field(_obj,0));
  int arg;
  arg = Int_val(_arg);
  cppobj->emit_tablesChanged(arg);
  CAMLreturn(Val_unit);
}

// unit -> int
extern "C" CAMLprim value prop_Asdf_tableCount1_get_int(value _obj, value _v0) {
  CAMLparam2(_obj,_v0);
  CAMLlocal1(_q0);
  Asdf *obj = (Asdf*) (Field(_obj,0));
  int ans = obj->tableCount();
    _q0 = Val_int (ans); 
  CAMLreturn(_q0);
}

// int -> unit
extern "C" CAMLprim value prop_Asdf_tableCount1_set_int(value _obj, value _v0) {
  CAMLparam2(_obj,_v0);
  CAMLlocal1(_q0);
  Asdf *obj = (Asdf*) (Field(_obj,0));
  int xx1;
  xx1 = Int_val(_v0);
  obj->setTableCount1(xx1);
  CAMLreturn(Val_unit);
}

extern "C" value stub_showDescription_emit_showDescriptionChanged(value _obj, value _arg) {
  CAMLparam2(_obj,_arg);
  Asdf *cppobj = (Asdf*) (Field(_obj,0));
  bool arg;
  arg = Bool_val(_arg);
  cppobj->emit_showDescriptionChanged(arg);
  CAMLreturn(Val_unit);
}

// unit -> bool
extern "C" CAMLprim value prop_Asdf_showDescription_get_bool(value _obj, value _v0) {
  CAMLparam2(_obj,_v0);
  CAMLlocal1(_q0);
  Asdf *obj = (Asdf*) (Field(_obj,0));
  bool ans = obj->canShowDescription();
    _q0 = Val_bool(ans); 
  CAMLreturn(_q0);
}

// bool -> unit
extern "C" CAMLprim value prop_Asdf_showDescription_set_bool(value _obj, value _v0) {
  CAMLparam2(_obj,_v0);
  CAMLlocal1(_q0);
  Asdf *obj = (Asdf*) (Field(_obj,0));
  bool xx1;
  xx1 = Bool_val(_v0);
  obj->setShowDescription(xx1);
  CAMLreturn(Val_unit);
}

extern "C" value stub_itemDescription_emit_itemDescriptionChanged(value _obj, value _arg) {
  CAMLparam2(_obj,_arg);
  Asdf *cppobj = (Asdf*) (Field(_obj,0));
  QString arg;
  arg = QString(String_val(_arg));
  cppobj->emit_itemDescriptionChanged(arg);
  CAMLreturn(Val_unit);
}

// unit -> string
extern "C" CAMLprim value prop_Asdf_itemDescription_get_string(value _obj, value _v0) {
  CAMLparam2(_obj,_v0);
  CAMLlocal1(_q0);
  Asdf *obj = (Asdf*) (Field(_obj,0));
  QString ans = obj->getDescription();
    _q0 = caml_copy_string(ans.toLocal8Bit().data() );
  CAMLreturn(_q0);
}

// string -> unit
extern "C" CAMLprim value prop_Asdf_itemDescription_set_string(value _obj, value _v0) {
  CAMLparam2(_obj,_v0);
  CAMLlocal1(_q0);
  Asdf *obj = (Asdf*) (Field(_obj,0));
  QString xx1;
  xx1 = QString(String_val(_v0));
  obj->setDescription(xx1);
  CAMLreturn(Val_unit);
}

// int -> int
int Asdf::tableLength(int x0) {
  CAMLparam0();
  CAMLlocal2(_ans,_qq0);
  value *closure = caml_named_value("Asdf_tableLength_int_int");
  Q_ASSERT_X(closure!=NULL, "Asdf::tableLength",
             "ocaml's closure `Asdf_tableLength_int_int` not found");
  value *args = new value[2];
  args[0] = caml_alloc_small(1, Abstract_tag);
  (*((Asdf **) &Field(args[0], 0))) = this;
    args[1] = Val_int (x0); 
  // delete args or not?
  _ans = caml_callbackN(*closure, 2, args);
  int cppans;
  cppans = Int_val(_ans);
  return cppans;
}
// int -> int -> string
QString Asdf::take(int x0,int x1) {
  CAMLparam0();
  CAMLlocal2(_ans,_qq0);
  value *closure = caml_named_value("Asdf_take_string_int_int");
  Q_ASSERT_X(closure!=NULL, "Asdf::take",
             "ocaml's closure `Asdf_take_string_int_int` not found");
  value *args = new value[3];
  args[0] = caml_alloc_small(1, Abstract_tag);
  (*((Asdf **) &Field(args[0], 0))) = this;
    args[1] = Val_int (x0); 
    args[2] = Val_int (x1); 
  // delete args or not?
  _ans = caml_callbackN(*closure, 3, args);
  QString cppans;
  cppans = QString(String_val(_ans));
  return cppans;
}
// int -> int
int Asdf::selectedIndexAt(int x0) {
  CAMLparam0();
  CAMLlocal2(_ans,_qq0);
  value *closure = caml_named_value("Asdf_selectedIndexAt_int_int");
  Q_ASSERT_X(closure!=NULL, "Asdf::selectedIndexAt",
             "ocaml's closure `Asdf_selectedIndexAt_int_int` not found");
  value *args = new value[2];
  args[0] = caml_alloc_small(1, Abstract_tag);
  (*((Asdf **) &Field(args[0], 0))) = this;
    args[1] = Val_int (x0); 
  // delete args or not?
  _ans = caml_callbackN(*closure, 2, args);
  int cppans;
  cppans = Int_val(_ans);
  return cppans;
}
// int -> int -> unit
void Asdf::setSelectedIndexAt(int x0,int x1) {
  CAMLparam0();
  CAMLlocal2(_ans,_qq0);
  value *closure = caml_named_value("Asdf_setSelectedIndexAt_unit_int_int");
  Q_ASSERT_X(closure!=NULL, "Asdf::setSelectedIndexAt",
             "ocaml's closure `Asdf_setSelectedIndexAt_unit_int_int` not found");
  value *args = new value[3];
  args[0] = caml_alloc_small(1, Abstract_tag);
  (*((Asdf **) &Field(args[0], 0))) = this;
    args[1] = Val_int (x0); 
    args[2] = Val_int (x1); 
  // delete args or not?
  caml_callbackN(*closure, 3, args);
}
// unit -> string
QString Asdf::currentPath() {
  CAMLparam0();
  CAMLlocal2(_ans,_qq0);
  value *closure = caml_named_value("Asdf_currentPath_string_unit");
  Q_ASSERT_X(closure!=NULL, "Asdf::currentPath",
             "ocaml's closure `Asdf_currentPath_string_unit` not found");
  _qq0 = caml_alloc_small(1, Abstract_tag);
  (*((Asdf **) &Field(_qq0, 0))) = this;
  _ans = caml_callback2(*closure, _qq0, Val_unit);
  QString cppans;
  cppans = QString(String_val(_ans));
  return cppans;
}
// unit -> unit
void Asdf::print_data() {
  CAMLparam0();
  CAMLlocal2(_ans,_qq0);
  value *closure = caml_named_value("Asdf_print_data_unit_unit");
  Q_ASSERT_X(closure!=NULL, "Asdf::print_data",
             "ocaml's closure `Asdf_print_data_unit_unit` not found");
  _qq0 = caml_alloc_small(1, Abstract_tag);
  (*((Asdf **) &Field(_qq0, 0))) = this;
  caml_callback2(*closure, _qq0, Val_unit);
}
// unit -> unit
void Asdf::init() {
  CAMLparam0();
  CAMLlocal2(_ans,_qq0);
  value *closure = caml_named_value("Asdf_init_unit_unit");
  Q_ASSERT_X(closure!=NULL, "Asdf::init",
             "ocaml's closure `Asdf_init_unit_unit` not found");
  _qq0 = caml_alloc_small(1, Abstract_tag);
  (*((Asdf **) &Field(_qq0, 0))) = this;
  caml_callback2(*closure, _qq0, Val_unit);
}
