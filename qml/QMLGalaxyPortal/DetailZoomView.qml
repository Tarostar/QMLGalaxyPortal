import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    id: detailZoom
    width: main.width
    height: main.height

    property alias actionBarTitle: detailZoomActionBar.actionBarTitle
    property alias title: textTitle.text
    property alias itemData: textData.text

    ActionBar {
        id: detailZoomActionBar
        width: parent.width
        backButton.visible: true
        copyButton.visible: true
        backState: main.state
        backSource: "DetailView.qml";
        onCopy: {
            textDataRaw.selectAll();
            textDataRaw.copy();
        }
    }
    Flickable {
        anchors.top: detailZoomActionBar.bottom
        width: parent.width
        height: parent.height - detailZoomActionBar.height
        contentWidth: textData.width
        contentHeight: textTitle.height + textData.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Text {
            id: textTitle
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
            text: ""
            font.pointSize: largeFonts ? 16 : 12
            font.bold: true
        }
        Text {
            id: textData
            anchors.left: parent.left
            anchors.top: textTitle.bottom
            anchors.margins: 10
            text: ""
            font.pointSize: largeFonts ? 16 : 12
            textFormat: Text.RichText
        }
        // Hidden copy of field for copying (Text fields don't have access to clipboard copy/cut/paste)
        EditBox {
            id: textDataRaw
            visible: false
            anchors.left: parent.left
            anchors.top: textData.bottom
            anchors.margins: 10
            readOnly: true
            text: textData.text
        }
    }
}
