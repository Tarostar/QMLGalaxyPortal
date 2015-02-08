import QtQuick 2.3

Rectangle {
    // Acccess to override default colours.
    property alias topColor: topLine.color
    property alias middleColor: middleLine.color
    property alias bottomColor: bottomLine.color

    property int margin : mmItemMargin

    height: 3 + margin

    Rectangle { id: topLine; color: "white"; width: parent.width; height: 1; anchors.verticalCenter: parent.verticalCenter }
    Rectangle { id: middleLine; color: "#cdcdc1"; width: parent.width; height: 1; anchors.top: topLine.bottom}
    Rectangle { id: bottomLine; color: "white"; width: parent.width; height: 1; anchors.top: middleLine.bottom }
}
