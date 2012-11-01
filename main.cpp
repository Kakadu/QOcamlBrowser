#include <QApplication>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"
#include "dataobject.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    DataObject d;
    viewer.rootContext()->setContextProperty("mainData", &d);
    viewer.setMainQmlFile(QLatin1String("qml/QOcamlBrowser/main.qml"));
    viewer.showExpanded();




    return app->exec();
}
