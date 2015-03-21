import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 2

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        color: parent.color
    }

    CheckBox {
        id: largeFonts
        anchors.top: separator.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: Screen.pixelDensity * 9
        scale: main.scale >= 2 ? 1.5 : 1
        text: qsTr("Large Fonts")
        checked: main.largeFonts
        onClicked: {
            main.largeFonts = !main.largeFonts;
        }
    }

}
