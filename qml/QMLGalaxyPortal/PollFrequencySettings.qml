import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3

Rectangle {
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 2

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        color: parent.color
    }

    Text {
        id: pollFrequencyTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Poll Frequency")
        font.pointSize: largeFonts ? 20 : 15
        font.bold: true
    }
    Text {
        id: pollFrequencyDescription
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pollFrequencyTitle.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: pollFrequencyField.value === 0 ? qsTr("No update polling") : qsTr("Poll server every ") + pollFrequencyField.value + qsTr(" minutes.")
        font.pointSize: largeFonts ? 16 : 12
    }
    Slider {
        id: pollFrequencyField
        anchors.top: pollFrequencyDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity * 2; anchors.rightMargin: Screen.pixelDensity * 2
        value: main.periodicPolls / 60000
        stepSize: 1
        minimumValue: 0
        maximumValue: 60
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
            // Set poll interval in ms (from minutes) - remember zero is no polling.
            main.periodicPolls = pollFrequencyField.value * 60000;
        }
    }
}
