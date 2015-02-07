#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QtCore/QUrl>
#include <QQmlEngine>
#include <QUrl>
#include <QtQml>
#include "ticker.h"
#include "bridge.h"

#include <QQuickItem>

int main(int argc, char *argv[])
{
    // Setup main event loop for the GUI.
    QGuiApplication app(argc, argv);
    app.setOrganizationName("UiO Project");
    app.setOrganizationDomain("github.com/Tarostar/QMLGalaxyPortal");
    app.setApplicationName("Galaxy Portal");

    // Setup background thread and bridge interface between thread and QML.
    Bridge* bridge = new Bridge();
    QThread* thread = new QThread;
    Ticker* ticker = new Ticker();
    ticker->moveToThread(thread);

    // Connect signals and slots.
    QObject::connect(ticker, SIGNAL(tick()), bridge, SLOT(tick()), Qt::BlockingQueuedConnection);
    QObject::connect(ticker, SIGNAL(getTickInterval()), bridge, SLOT(getTickInterval()), Qt::BlockingQueuedConnection);
    QObject::connect(thread, SIGNAL(started()), ticker, SLOT(mainThread()));
    QObject::connect(ticker, SIGNAL(finished()), thread, SLOT(quit()));
    QObject::connect(ticker, SIGNAL(finished()), ticker, SLOT(deleteLater()));
    QObject::connect(ticker, SIGNAL(finished()), thread, SLOT(deleteLater()));
    QObject::connect(ticker, SIGNAL(finished()), bridge, SLOT(deleteLater()));
    thread->start();



    // Setup QQuickView window for displaying Qt Quick GUI and connect with background thread through the bridge interface.
    QtQuick2ApplicationViewer viewer;    
    viewer.rootContext()->setContextProperty("Bridge", bridge);

    viewer.setMainQmlFile(QStringLiteral("qml/QMLGalaxyPortal/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
