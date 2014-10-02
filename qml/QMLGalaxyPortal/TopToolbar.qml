import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {

    color: "burlywood"

    // expose toolbar properties so they can be changed
    property alias toolbarTitle: title
    property alias settingsButton: settings
    property alias backButton: back
    property url backSource: ""
    property url backState: ""

    // draws buttons at original size for a given resolution (i.e. mdpi, hdpi, xhdpi or xxhdpi)
    property string iconRoot: "qrc:/resources/resources/icons/" + res[resIndex] + "/"

    /*Image {
        // TODO: image used must depend on resolution
        id: toolbarImage
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 5
        height: parent.height / 2
        width: parent.height / 2
        fillMode: Image.PreserveAspectFit
        source: "qrc:/resources/resources/icons/biotech-32.png"
    }*/

    Text {
        id: title
        anchors.left: back.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: "Galaxy Portal"
        font.pixelSize: 15
    }

    // back button
    Button {
        id: back
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
        }
    }

    // settings button
    Button {
        id: settings
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
