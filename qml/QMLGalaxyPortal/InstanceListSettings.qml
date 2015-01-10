import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    // Set rect to size of all children (+ margin) - or zero if buttons not shown.
    height: screen.instanceList.length > 0 || (screen.dataKey.length > 0 && screen.dataSource.length > 0) ? childrenRect.height + Screen.pixelDensity * 2 : 0

    ImageButton {
        id: save
        visible: screen.dataKey.length > 0 && screen.dataSource.length > 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 5
        height: image.sourceSize.height
        width: image.sourceSize.width
        imageSource: "qrc:/resources/resources/images/green_button_100_32.png"
        pressedImageSource: "qrc:/resources/resources/images/green_button_100_32_pressed.png"
        title: "Save"
        onClicked: {
            focus = true;
            if (screen.dataSource.length > 0 && screen.dataKey.length > 0) {
                screen.instanceList.length > 0 ? screen.instanceList += "," + screen.dataSource : screen.instanceList = screen.dataSource;
                screen.instanceListKeys.length > 0 ? screen.instanceListKeys += "," + screen.dataKey : screen.instanceListKeys = screen.dataKey;
            }
        }
    }
    ImageButton {
        id: load
        visible: screen.instanceList.length > 0
        anchors.left: save.right
        anchors.top: parent.top
        anchors.margins: 5
        height: image.sourceSize.height
        width: image.sourceSize.width
        imageSource: "qrc:/resources/resources/images/green_button_100_32.png"
        pressedImageSource: "qrc:/resources/resources/images/green_button_100_32_pressed.png"
        title: "Load"
        onClicked: {
            focus = true;
            mainLoader.source = "InstanceList.qml";
            mainLoader.item.populateInstanceModel();
        }
    }
}
