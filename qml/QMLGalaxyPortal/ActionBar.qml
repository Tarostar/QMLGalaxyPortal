import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {

    color: "burlywood"
    height: mmItemHeight

    // Expose action bar properties so they can be changed.
    property alias actionBarTitle: title.text

    // Buttons - primarily so they can be shown or hidden.
    property alias settingsButton: actionSettings
    property alias webViewButton: actionWebView
    property alias backButton: actionBack
    property alias pasteButton: actionPaste
    property alias copyButton: actionCopy

    // Destination for back button.
    property string backSource: ""
    property string backState: ""

    // Signal that buttons were clicked.
    signal paste()
    signal copy()

    // Draws buttons at original size for a given resolution (i.e. mdpi, hdpi, xhdpi or xxhdpi).
    property string iconRoot: "qrc:/resources/resources/icons/" + res[resIndex] + "/"

    // Title shown in Action Bar (can be overriden using actionBarTitle alias for custom headings).
    Text {
        id: title
        anchors.left: actionBack.right
        anchors.leftMargin: mmItemMargin / 2
        anchors.right: actionCopy.visible ? actionCopy.left : actionPaste.visible ? actionPaste.left : actionSettings.visible ? actionSettings.left : parent.right
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: qsTr("Galaxy Portal")
        font.pointSize: largeFonts ? 18 : 15
    }

    // Back button.
    ImageButton {
        id: actionBack
        visible: false
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: mmItemMargin
        imageSource: iconRoot + "ic_action_back.png"
        pressedImageSource: iconRoot + "ic_action_back_pressed.png"
        onClicked: {
            mainLoader.source = backSource;
            main.state = backState
            if (main.state === "")
            {
                // Reset trackers when returning to main screen.
                main.currentHistory = "";
                main.currentHistoryID = "";
                main.currentJobID = "";
            }
        }
    }

    // Copy button.
    ImageButton {
        id: actionCopy
        visible: false
        anchors.right: actionPaste.visible ? actionPaste.left : actionSettings.left
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: mmItemMargin
        imageSource: iconRoot + "ic_action_copy.png"
        pressedImageSource: iconRoot + "ic_action_copy_pressed.png"
        onClicked: {
            copy();
        }
    }

    // Paste button.
    ImageButton {
        id: actionPaste
        visible: false
        anchors.right: actionSettings.left
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: mmItemMargin
        imageSource: iconRoot + "ic_action_paste.png"
        pressedImageSource: iconRoot + "ic_action_paste_pressed.png"
        onClicked: {
            paste();
        }
    }

    // WebView button
    // TODO: enable when Qt WebView works better with scrollable and Qt WebEngine is better supported for cross platform.
    ImageButton {
        id: actionWebView
        visible: false
        anchors.right: actionSettings.left
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: mmItemMargin
        imageSource: iconRoot + "ic_action_web_site.png"
        pressedImageSource: iconRoot + "ic_action_web_site_pressed.png"
        onClicked: {
            mainLoader.source = "WebView.qml";
        }
    }

    // Settings button.
    ImageButton {
        id: actionSettings
        visible: true
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: mmItemMargin
        imageSource: iconRoot + "ic_action_settings.png"
        pressedImageSource: iconRoot + "ic_action_settings_pressed.png"
        onClicked: {
            mainLoader.source = "Settings.qml";
        }
    }


}
