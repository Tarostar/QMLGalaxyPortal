# Add more folders to ship with the application, here
folder_01.source = qml/QMLGalaxyPortal
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

qtHaveModule(webengine) {
        QT += webengine
        DEFINES += QT_WEBVIEW_WEBENGINE_BACKEND
}

# Qt Modules for C++
QT += qml quick multimedia

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# C++
CONFIG += c++11

SOURCES += main.cpp \
    ticker.cpp \
    bridge.cpp

HEADERS += \
    ticker.h \
    bridge.h

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

# Android / QML / Java / Other
OTHER_FILES += \
    android/AndroidManifest.xml \
    images/QMLGalaxyPortal80.png \
    qml/QMLGalaxyPortal/ActionBar.qml \
    qml/QMLGalaxyPortal/JSONDataset.qml \
    qml/QMLGalaxyPortal/ImageButton.qml \
    qml/QMLGalaxyPortal/PollFrequencySettings.qml \
    qml/QMLGalaxyPortal/Dataset.qml \
    qml/QMLGalaxyPortal/DetailView.qml \
    qml/QMLGalaxyPortal/DetailZoomView.qml \
    qml/QMLGalaxyPortal/InstanceListSettings.qml \
    qml/QMLGalaxyPortal/AdvancedFieldsSettings.qml \
    qml/QMLGalaxyPortal/AudioNotifications.qml \
    qml/QMLGalaxyPortal/EditBox.qml \
    qml/QMLGalaxyPortal/FieldSettings.qml \
    qml/QMLGalaxyPortal/Flip.qml \
    qml/QMLGalaxyPortal/GalaxyKeyBaseAuth.qml \
    qml/QMLGalaxyPortal/GalaxyKeySettings.qml \
    qml/QMLGalaxyPortal/HistoryDelegate.qml \
    qml/QMLGalaxyPortal/InstanceDelegate.qml \
    qml/QMLGalaxyPortal/InstanceList.qml \
    qml/QMLGalaxyPortal/JobDelegate.qml \
    qml/QMLGalaxyPortal/JobItem.qml \
    qml/QMLGalaxyPortal/JSONListModel.qml \
    qml/QMLGalaxyPortal/Line.qml \
    qml/QMLGalaxyPortal/main.qml \
    qml/QMLGalaxyPortal/PasscodeChallenge.qml \
    qml/QMLGalaxyPortal/PasscodeSettings.qml \
    qml/QMLGalaxyPortal/ScrollBar.qml \
    qml/QMLGalaxyPortal/Separator.qml \
    qml/QMLGalaxyPortal/Settings.qml \
    qml/QMLGalaxyPortal/WebView.qml \
    qml/QMLGalaxyPortal/Welcome.qml \
    qml/QMLGalaxyPortal/utils.js \
    qml/QMLGalaxyPortal/scrollbar.svg \
    qml/QMLGalaxyPortal/ScaleSettings.qml

# Icons / Images / Sounds
RESOURCES += \
    resources.qrc

# Used for iOS deployment
macx:CONFIG += x86_64 # 64 bit intel
#macx:CONFIG += ppc      # 32 bit PPC
#macx:CONFIG += ppc64   # 64 bit PPC
#macx:CONFIG += x86


