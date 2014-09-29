import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Dialog {
    visible: false
    title: "Settings"


    contentItem:
        Rectangle {
            id: backButton
            color: "burlywood"
            width: parent.width
            height: Screen.pixelDensity * 9
        }
        Rectangle {
            color: "lightskyblue"
            /*implicitWidth: 400
            implicitHeight: 100*/
            anchors.top: backButton.bottom
            height: parent.height
            width: parent.width
            Text {
                text: "Do settings here"
                color: "navy"
                anchors.centerIn: parent
            }
        }
}
