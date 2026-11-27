import QtQuick

// Eckiger Knopf, beim Darüberfahren invertiert (dunkel auf beige)
Rectangle {
    id: tile

    property string label: ""

    signal clicked()

    width: 120
    height: 36
    color: area.containsMouse ? "#DAD4BB" : Qt.rgba(0.098, 0.086, 0.09, 0.88)
    border.width: 1
    border.color: "#756C63"

    Text {
        anchors.centerIn: parent
        text: tile.label
        color: area.containsMouse ? "#191617" : "#DAD4BB"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 13
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: tile.clicked()
    }
}
