import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {

    color: "burlywood"

    // Expose action bar properties so they can be changed.
    property alias actionBarTitle: title.text

    // Buttons - primarily so they can be shown or hidden.
    property alias settingsButton: actionSettings
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
        anchors.leftMargin: 5
        anchors.right: actionCopy.visible ? actionCopy.left : actionPaste.visible ? actionPaste.left : actionSettings.visible ? actionSettings.left : parent.right
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: "Galaxy Portal"
        font.pointSize: 15
    }

    // Back button.
    ImageButton {
        id: actionBack
        visible: false
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: 10
        imageSource: iconRoot + "ic_action_back.png"
        pressedImageSource: iconRoot + "ic_action_back_pressed.png"
        onClicked: {
            mainLoader.source = backSource;
            screen.state = backState
            if (screen.state === "")
            {
                // Reset trackers when returning to main screen.
                screen.currentHistory = "";
                screen.currentHistoryID = "";
                screen.currentJobID = "";
            }
        }
    }

    // Copy button.
    ImageButton {
        id: actionCopy
        visible: false
        anchors.right: actionPaste.visible ? actionPaste.left : actionSettings.visible ? actionSettings.left : parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: 10
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
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: 10
        imageSource: iconRoot + "ic_action_paste.png"
        pressedImageSource: iconRoot + "ic_action_paste_pressed.png"
        onClicked: {
            paste();
        }
    }

    // Settings button.
    ImageButton {
        id: actionSettings
        visible: false
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: 10
        imageSource: iconRoot + "ic_action_settings.png"
        pressedImageSource: iconRoot + "ic_action_settings_pressed.png"
        onClicked: {
            mainLoader.source = "Settings.qml";
        }
    }


}
