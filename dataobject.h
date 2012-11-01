#ifndef DATAOBJECT_H
#define DATAOBJECT_H

#include <QObject>
#include <QDebug>

class DataObject : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(int tableCount READ tableCount)
    //Q_PROPERTY (int boo READ boo WRITE setBoo NOTIFY booChanged)
    QList< QList<QString> > data;
    QList<int> selectedItems;
public:
    explicit DataObject(QObject *parent = 0);
    Q_INVOKABLE int tableCount() { return data.length(); }
    Q_INVOKABLE int tableLength(int n) {
        return data.at((n)).length();
    }
    Q_INVOKABLE QString take(int n,int k) {
        return data.at(n).at(k);
    }
    Q_INVOKABLE int selectedIndexAt(int n) {
        return selectedItems.at(n);
    }
    Q_INVOKABLE void setSelectedIndexAt(int n,int k) {
        qDebug() << QString("Setting selected index at %1 to %2").arg(n).arg(k);
        selectedItems[n] = k;
    }
    Q_INVOKABLE QString currentPath() {
        QString ans = data.at(0).at(selectedItems.at(0));
        for (int i=1; i<data.length(); ++i) {
            ans += QString("/") + data.at(i).at(selectedItems.at(i));
        }
        // TODO: use something like StringBuilder
        return ans;
    }

/*
    //Q_INVOKABLE int boo() { return _boo; }
    Q_INVOKABLE void setBoo(int x) {
        if (x != _boo) {
            qDebug() << "new boo = " << x;
            _boo = x;
            emit booChanged(x);
        }
    }*/
signals:
    void booChanged(int);
public slots:

};

#endif // DATAOBJECT_H
