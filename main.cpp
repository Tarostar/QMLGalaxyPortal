#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QtCore/QUrl>

#ifdef QT_WEBVIEW_WEBENGINE_BACKEND
#include <QtWebEngine>
#endif // QT_WEBVIEW_WEBENGINE_BACKEND

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("UiO Project");
    app.setOrganizationDomain("github.com/Tarostar/QMLGalaxyPortal");
    app.setApplicationName("Galaxy Portal");

    #ifdef QT_WEBVIEW_WEBENGINE_BACKEND
        QtWebEngine::initialize();
    #endif // QT_WEBVIEW_WEBENGINE_BACKEND

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/QMLGalaxyPortal/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
