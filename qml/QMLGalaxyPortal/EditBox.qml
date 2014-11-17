import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    // Expose input properties.
    property alias text: input.text
    property alias echo: input.echoMode
    property alias inputMethodHints: input.inputMethodHints
    property alias hasActiveFocus: input.activeFocus
    property alias readOnly : input.readOnly

    // Signal that editing is done.
    signal editDone (string text)

    // Access to TextInput functions.
    function copy() {
        input.copy()
    }

    function paste() {
        input.paste()
    }

    function selectAll() {
        input.selectAll()
    }

    width: screen.width
    height: Screen.pixelDensity * 9
    color: "white"

    Rectangle { color: "#cdcdc1"; width: parent.width; height: 1; anchors.top: parent.top }

    TextInput {
        id: input
        color: "black"
        // Workaround for QTBUG-36515.
        selectByMouse: Qt.platform.os !== "android"
        font.pointSize: 16
        width: parent.width - 16
        anchors.centerIn: parent
        onAccepted: {
            Qt.inputMethod.commit()
            Qt.inputMethod.hide()
            textfield.accepted()
        }
        onEditingFinished: {
            // Edit field lost focus, or return/enter was pressed so send signal.
            editDone(text);
        }
        // propagateComposedEvents does not work with TextInput.
        /*MouseArea {
            anchors.fill: parent
            propagateComposedEvents : true
            onPressAndHold: {
                input.paste()
                input.cursorPosition = input.selectionEnd;
                mouse.accepted = false
            }

            onClicked: {
                mouse.accepted = false
            }
        }*/
    }

    Rectangle { color: "#cdcdc1"; width: parent.width; height: 1; anchors.bottom: parent.bottom }
}

