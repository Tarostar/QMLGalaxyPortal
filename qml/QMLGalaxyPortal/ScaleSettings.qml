import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3

Rectangle {
    // IMPORTANT: If slider is set with minimumValue 1 then it keeps resetting, so adjust from scale starting at 0

    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 2

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        color: parent.color
    }

    Text {
        id: scaleTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Size Scale")
        font.pointSize: largeFonts ? 20 : 15
        font.bold: true
    }
    Text {
        id: scaleDescription
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: scaleTitle.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("x") + main.scale
        font.pointSize: largeFonts ? 16 : 12
    }
    Slider {
        id: scaleField
        anchors.top: scaleDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity * 2; anchors.rightMargin: Screen.pixelDensity * 2
        value: main.scale - 1
        stepSize: 0.5
        minimumValue: 0
        maximumValue: 2
        updateValueWhileDragging: false
        tickmarksEnabled: true
        style: SliderStyle {
            groove: Rectangle {
                color: "white"
                border.color: "gray"
                border.width: Screen.pixelDensity / 4
                implicitHeight: Screen.pixelDensity * main.scale
                radius: Screen.pixelDensity / 2 * main.scale
            }
            handle: Rectangle {
                anchors.centerIn: parent
                color: control.pressed ? "lightgray" : "white"
                border.color: "gray"
                border.width: Screen.pixelDensity / 4
                implicitWidth: Screen.pixelDensity * 5 * main.scale
                implicitHeight: Screen.pixelDensity * 5 * main.scale
                radius: Screen.pixelDensity * 4 * main.scale
            }
        }
        onValueChanged: {
            main.scale = scaleField.value + 1;
        }
    }
}
