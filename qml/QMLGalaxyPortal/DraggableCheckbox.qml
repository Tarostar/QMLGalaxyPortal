import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: rect

    // Name visible to user.
    property string fieldName: ""
    // Name of field in Galaxy system.
    property string fieldID: ""

    // Signal that this item has been dragged and released.
    signal dropItem

    width: 100
    height: Screen.pixelDensity * 9
    border.color: "black"
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#cdb79e" }
        GradientStop { position: 0.5; color: "#ffebcd" }
        GradientStop { position: 1.0; color: "#cdb79e" }
    }
    border.width: 1
    // First declare the main mouse area so that the checkbox click mouse area will be on top of it.
    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        drag.target: rect
        drag.axis: Drag.XAxis
        drag.minimumX: 0
        drag.maximumX: container.width - rect.width
        onReleased: {
            rect.z = 0;
            rect.dropItem();
        }
        onPressed: {
            rect.color = "red";
            rect.z = 1;
        }
    }
    CheckBox {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: fieldName
        checked: findField(fieldID)
        onClicked: {
            toggleField(fieldID);
        }
    }
}
