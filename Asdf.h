/*
 * Generated at 2012-11-26 15:37:14.229132
 */
#ifndef Asdf_H
#define Asdf_H

#include <QtCore/QObject>
#include <QtCore/QDebug>
#include "kamlo.h"

class Asdf : public QObject
{
  Q_OBJECT
  int _tableCount1;
  bool _showDescription;
  QString _itemDescription;
public:
  Q_PROPERTY(int tableCount1 READ tableCount NOTIFY tablesChanged)
  Q_INVOKABLE int tableCount() { return _tableCount1; }
  void setTableCount1(int v) {
    if (_tableCount1 != v) {
      _tableCount1 = v;
      qDebug() << QString("emitted tablesChanged %1").arg(v);
      emit tablesChanged(v);
  } }
  void emit_tablesChanged(int arg1) {
    qDebug() << QString("emitted tablesChanged %1").arg(arg1);
    emit tablesChanged(arg1);
  }

  Q_PROPERTY(bool showDescription READ canShowDescription NOTIFY showDescriptionChanged)
  Q_INVOKABLE bool canShowDescription() { return _showDescription; }
  void setShowDescription(bool v) {
    if (_showDescription != v) {
      _showDescription = v;
      qDebug() << "showDescription changed";
      emit showDescriptionChanged(v);
  } }
  void emit_showDescriptionChanged(bool arg1) {
    qDebug() << "emitted showDescriptionChanged";    emit showDescriptionChanged(arg1);
  }

  Q_PROPERTY(QString itemDescription WRITE setDescription READ getDescription NOTIFY itemDescriptionChanged)
  Q_INVOKABLE QString getDescription() { return _itemDescription; }
  Q_INVOKABLE void setDescription(QString v) {
    if (_itemDescription != v) {
      _itemDescription = v;
      qDebug() << "itemDescription changed";
      emit itemDescriptionChanged(v);
  } }
  void emit_itemDescriptionChanged(QString arg1) {
    qDebug() << "emitted itemDescriptionChanged";    emit itemDescriptionChanged(arg1);
  }

public:
  explicit Asdf(QObject *parent = 0) : QObject(parent) {}
  Q_INVOKABLE int tableLength(int x0);
  Q_INVOKABLE QString take(int x0,int x1);
  Q_INVOKABLE int selectedIndexAt(int x0);
  Q_INVOKABLE void setSelectedIndexAt(int x0,int x1);
  Q_INVOKABLE QString currentPath();
  Q_INVOKABLE void print_data();
  Q_INVOKABLE void init();
public slots:
signals:
  Q_INVOKABLE void tablesChanged(int);
  Q_INVOKABLE void showDescriptionChanged(bool);
  Q_INVOKABLE void itemDescriptionChanged(QString);
};
#endif

