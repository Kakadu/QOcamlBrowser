#include <QApplication>
#include <QDeclarativeContext>
#include "qmlapplicationviewer.h"

#include "Asdf.h"
#include "kamlo.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    caml_main(argv);
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    Asdf d;
    d.init();
    viewer.rootContext()->setContextProperty("mainData", &d);
    viewer.setMainQmlFile(QLatin1String("qml/QOcamlBrowser/main.qml"));
    viewer.showExpanded();




    return app->exec();
}
