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
    /*QList<QString> lst1;
    lst1 <<"a" << "b" << "c";
    QList<QString> lst2;
    lst2 << "1" << "2" << "3";
    QList<QString> lst3;
    lst3 << "x" << "y" << "z";
    data << lst1;// << lst2 << lst3;*/
    data = initData();
    foreach(QList<QString> x, data) {
        Q_UNUSED(x);
        selectedItems.push_back(-1);
    }
    Q_ASSERT(selectedItems.length() == data.length());
}


void DataObject::doOCaml(int lastAffectedColumn) {
    CAMLparam0();
    CAMLlocal3(_ans,cli,cons);
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
    //arg = caml_copy_string(path.toLocal8Bit().data());
    _ans = caml_callback(*closure, cli);
    QList<QList<QString> > ans;
    QListQListQString_of_caml(_ans,cli,cons,ans);
    data.clear();
    emit tablesChanged(0);
    data = ans;
    emit tablesChanged(data.length());
    print_data();
    qDebug() << "Selected items are:";
    foreach (int i, selectedItems)
        qDebug() << i << ", ";
    while (selectedItems.length() > lastAffectedColumn+1) {
        selectedItems.pop_back();
    }
    Q_ASSERT(selectedItems.length() == lastAffectedColumn+1);
    while (selectedItems.length() < data.length())
        selectedItems.push_back(-1);
    qDebug() << "Selected items are:";
    foreach (int i, selectedItems)
        qDebug() << i << ", ";
    CAMLreturn0;
}
