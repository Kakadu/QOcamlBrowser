#include "dataobject.h"

DataObject::DataObject(QObject *parent) :
    QObject(parent)
{
    QList<QString> lst1;
    lst1 <<"a" << "b" << "c";
    QList<QString> lst2;
    lst2 << "1" << "2" << "3";
    QList<QString> lst3;
    lst3 << "x" << "y" << "z";
    data << lst1 << lst2 << lst3;

    foreach(QList<QString> x, data) {
        Q_UNUSED(x);
        selectedItems.push_back(0);
    }
}
