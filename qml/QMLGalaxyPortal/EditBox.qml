import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    property alias text: input.text
    property alias echo: input.echoMode

    // Signal that editing is done
    signal editDone (string text)

    width: screen.width
    height: Screen.pixelDensity * 9
    color: "white"

    // Edit box separator (lighter at the top, darker at the bottom).
    Rectangle { color: "#cdcdc1"; width: parent.width; height: 1; anchors.bottom: parent.top }
    Rectangle { color: "white"; width: parent.width; height: 1 }
    Rectangle { color: "#cdcdc1"; width: parent.width; height: 1; anchors.bottom: parent.bottom }
    TextInput {
        id: input
        color: "black"
        selectionColor: "green"
        selectByMouse: true
        font.pixelSize: 16
        width: parent.width-16
        anchors.centerIn: parent
        focus: true
        onEditingFinished: {
            // edit field lost focus, or return/enter was pressed so send signal
            editDone(text);
        }
    }
}

