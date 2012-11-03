#include "dataobject.h"

QList<QList<QString> > initData() {
    CAMLparam0();
    QList<QList<QString> > ans;
    CAMLlocal3(_ans,head1,head2);
    value *closure = caml_named_value("caml_init_data");
    Q_ASSERT(closure!= NULL);
    _ans = caml_callback(*closure, Val_unit);
    QListQListQString_of_caml(_ans,head1,head2,ans);
    CAMLreturnT(QList<QList<QString> >,ans);
}

DataObject::DataObject(QObject *parent) :
    QObject(parent)
{
    data = initData();
    foreach(QList<QString> x, data) {
        Q_UNUSED(x);
        selectedItems.push_back(-1);
    }
    Q_ASSERT(selectedItems.length() == data.length());
    _itemDescription = "";
    _showDescription = false;
}


void DataObject::doOCaml(int lastAffectedColumn) {
    CAMLparam0();
    CAMLlocal4(_ans,cli,cons,_ans_msg);
    cli = Val_emptylist;
    QString debugPath = "";
    for (int i=lastAffectedColumn; i>=0; --i) {
        cons = caml_alloc(2,0);
        Store_field(cons, 0, Val_int( selectedIndexAt(i) ));
        debugPath += QString("/%1").arg(selectedIndexAt(i));
        Store_field( cons, 1, cli );
        cli = cons;
    }
    //qDebug() << "Debug Path = " << debugPath;
    value *closure = caml_named_value("caml_path_changed");
    Q_ASSERT(closure!= NULL);
    // this function take int list of selected items
    // path_changed: int list -> string string list * string option
    _ans = caml_callback(*closure, cli);
    _ans_msg = Field(_ans,1);  // is string option
    _ans = Field(_ans,0);      // is string string list
    QList<QList<QString> > ans;
    QListQListQString_of_caml(_ans,cli,cons,ans);
    data.clear();
    emit tablesChanged(0);
    data = ans;
    emit tablesChanged(data.length());
    //print_data();
    while (selectedItems.length() > lastAffectedColumn+1) {
        selectedItems.pop_back();
    }
    Q_ASSERT(selectedItems.length() == lastAffectedColumn+1);
    while (selectedItems.length() < data.length())
        selectedItems.push_back(-1);
    qDebug() << "Selected items are:";
    foreach (int i, selectedItems)
        qDebug() << i << ", ";

    // setting description
    if (_ans_msg != Val_none) {
        setDescription( QString( String_val(Val_of_some(_ans_msg)) ) );
        setShowDescription(true);
    }
    CAMLreturn0;
}
