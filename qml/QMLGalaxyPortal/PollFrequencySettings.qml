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
        margin: Screen.pixelDensity * 5
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
        font.pointSize: 15
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
        font.pointSize: 12
    }
    Slider {
        id: pollFrequencyField
        anchors.top: pollFrequencyDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        value: periodicPolls / 60000
        stepSize: 1
        minimumValue: 0
        maximumValue: 60
        style: SliderStyle {
            groove: Rectangle {
                implicitHeight: 4
                color: "white"
                border.color: "gray"
                border.width: 1
                radius: 2
            }
            handle: Rectangle {
                anchors.centerIn: parent
                color: control.pressed ? "lightgray" : "white"
                border.color: "gray"
                border.width: 1
                implicitWidth: 18
                implicitHeight: 18
                radius: 12
            }
        }
        onValueChanged: {
            // Set poll interval in ms (from minutes) - remember zero is no polling.
            main.periodicPolls = pollFrequencyField.value * 60000;
        }
    }
}
