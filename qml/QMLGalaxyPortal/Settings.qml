import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    id: settings
    width: screen.width
    height: screen.height
    color:"red"

    /*Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width
        height: 30 //Screen.pixelDensity * 9

        color: "burlywood"
    }*/
    TopToolbar {
        id: settingsToolbar
        width: screen.width
        height: Screen.pixelDensity * 9
        settingsButton.visible: false
        backButton.visible: true
    }
    /*Text {
        text:"First page loaded"
    }*/

    /*Button {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        width: 50
        anchors.rightMargin: 10
        image: "qrc:/resources/resources/icons/mdpi/ic_action_settings.png"
        pressedImage: "qrc:/resources/resources/icons/mdpi/ic_action_settings_pressed.png"
        onClicked: {
            mainLoader.source = "";
        }
    }*/

    /*Button{id:buttonPage1
     //Position the button in page1Container rectangle
            anchors.bottom:page1Container.bottom;
            anchors.right: page1Container.right
            MouseArea {
                    anchors.fill: parent
                    onClicked: {page1.source="Page2.qml";
                    buttonPage1.z=-1 //Hide button
                    }
            }
     }*/
}
