# Add more folders to ship with the application, here
folder_01.source = qml/QMLGalaxyPortal
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

qtHaveModule(webengine) {
        QT += webengine
        DEFINES += QT_WEBVIEW_WEBENGINE_BACKEND
}

QT += qml quick

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml \
    images/QMLGalaxyPortal80.png \
    qml/QMLGalaxyPortal/ActionBar.qml \
    qml/QMLGalaxyPortal/JSONDataset.qml \
    qml/QMLGalaxyPortal/ImageButton.qml \
    qml/QMLGalaxyPortal/PollFrequencySettings.qml \
    qml/QMLGalaxyPortal/DetailView.qml \
    qml/QMLGalaxyPortal/DetailZoomView.qml \
    qml/QMLGalaxyPortal/InstanceListSettings.qml \
    qml/QMLGalaxyPortal/AudioNotifications.qml

RESOURCES += \
    resources.qrc

macx:CONFIG += x86_64 # 64 bit intel
#macx:CONFIG += ppc      # 32 bit PPC
#macx:CONFIG += ppc64   # 64 bit PPC
#macx:CONFIG += x86
