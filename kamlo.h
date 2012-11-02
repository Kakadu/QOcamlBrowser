#ifndef KAMLO_H
#define KAMLO_H

extern "C" {
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/callback.h>
}

#define Val_none Val_int(0)
#define Val_of_some(v) Field(v,0)

static inline value
Some_val(value v) { // 'a -> 'a option
  CAMLparam1(v);
  CAMLlocal1(ans);
  ans = caml_alloc_small(1,0);
  Field(ans,0)=v;
  CAMLreturn(ans);
}

/*
#define Kamlolist_of_QList(conv,lst,ans_name) \
{\
    if (lst.length()==0) \
        ans_name = Val_emptylist;\
    else {\
        auto i = lst.end() --;\
        for (;;) {\

    }\
}
*/
#define QListQListQString_of_caml(_ans,head1,head2,ans) {\
while (_ans != Val_emptylist) {\
    head1 = Field(_ans,0);\
    QList<QString> tempList;\
    while (head1 != Val_emptylist) {\
        head2 = Field(head1,0);\
        tempList.push_back( QString(String_val(head2)) );\
        head1 = Field(head1,1);\
    }\
    ans.push_back(tempList);\
    _ans = Field(_ans,1);\
}}

#endif
