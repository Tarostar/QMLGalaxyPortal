import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {

    color: "burlywood"

    // Expose action bar properties so they can be changed.
    property alias actionBarTitle: title.text

    // Buttons - primarily so they can be shown or hidden.
    property alias settingsButton: actionSettings
    property alias backButton: actionBack

    // Destination for back button.
    property string backSource: ""
    property string backState: ""

    // Draws buttons at original size for a given resolution (i.e. mdpi, hdpi, xhdpi or xxhdpi).
    property string iconRoot: "qrc:/resources/resources/icons/" + res[resIndex] + "/"

    /*Image {
        // TODO: image used must depend on resolution
        id: actionBarImage
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 5
        height: parent.height / 2
        width: parent.height / 2
        fillMode: Image.PreserveAspectFit
        source: "qrc:/resources/resources/icons/biotech-32.png"
    }*/

    // Title shown in Action Bar (can be overriden using actionBarTitle alias for custom headings).
    Text {
        id: title
        anchors.left: actionBack.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: "Galaxy Portal"
        font.pointSize: 15
    }

    // Back button.
    Button {
        id: actionBack
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

    // Details button.
    /*Button {
        id: details
        anchors.right: settings.left
        anchors.verticalCenter: parent.verticalCenter
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: 10
        imageSource: iconRoot + "ic_action_view_as_list.png"
        pressedImageSource: iconRoot + "ic_action_view_as_list_pressed.png"
        onClicked: {
            mainLoader.source = "Details.qml";
        }
    }*/

    // Settings button.
    Button {
        id: actionSettings
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
