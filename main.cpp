#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("UiO Project");
    app.setOrganizationDomain("github.com/Tarostar/QMLGalaxyPortal");
    app.setApplicationName("Galaxy Portal");

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/QMLGalaxyPortal/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
