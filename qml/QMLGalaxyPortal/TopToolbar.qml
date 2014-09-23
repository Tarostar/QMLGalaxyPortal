import QtQuick 2.3

Rectangle {
    color: "burlywood"

    Image {
        // TODO: image used must depend on resolution
        id: toolbarImage
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 5
        height: parent.height / 2
        width: parent.height / 2
        fillMode: Image.PreserveAspectFit
        source: "qrc:/resources/resources/icons/biotech-32.png"
    }

    Text {
        id: toolbarTitle
        anchors.left: toolbarImage.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: "Galaxy Portal"
        font.pixelSize: 15
    }

    Button {
        anchors.left: toolbarTitle.right
        anchors.leftMargin: 10
        height: parent.height / 2
        width: parent.height / 2
        icon: "qrc:/resources/resources/icons/search.png"
        onClicked: {
            // TODO: test
            toolbarTitle.text = "click-click";
            // ensure keyboard is hidden and reset any states before
            // showing the dialog
            /*if (!settingsDialog.show) {
                Qt.inputMethod.hide()
                root.state = ""
            }

            // toggle the dialog
            settingsDialog.show = !settingsDialog.show*/
        }
    }


}
