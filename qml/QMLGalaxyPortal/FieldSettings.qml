import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 5

    property alias advancedFields: advanced_fields.checked

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        margin: Screen.pixelDensity * 5
        color: parent.color
    }

    Text {
        id: fieldConfigTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Flipped History Fields")
        font.pointSize: 15
        font.bold: true
    }
    Text {
        id: fieldConfigDescription
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: fieldConfigTitle.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Fields shown for history items when flipped.")
        font.pointSize: 12
    }
    CheckBox {
        id: advanced_fields
        anchors.top: fieldConfigDescription.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        height: Screen.pixelDensity * 9
        text: qsTr("Enable Advanced Fields")
        checked: main.advancedFields
        onClicked: {
            main.advancedFields = !main.advancedFields;
        }
    }
}
