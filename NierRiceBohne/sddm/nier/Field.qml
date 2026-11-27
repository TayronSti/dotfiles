import QtQuick

// Input field: square, dark, thin border (like the password field on the lock screen)
Rectangle {
    id: field

    property alias text: input.text
    property alias echoMode: input.echoMode
    property string placeholder: ""

    signal accepted()
    signal tabbed()

    function focusInput() {
        input.forceActiveFocus()
    }

    width: 340
    height: 46
    color: Qt.rgba(0.098, 0.086, 0.09, 0.88)
    border.width: 1
    border.color: input.activeFocus ? "#DAD4BB" : "#756C63"

    TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: 12
        verticalAlignment: TextInput.AlignVCenter
        color: "#DAD4BB"
        selectionColor: "#756C63"
        selectedTextColor: "#191617"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
        clip: true
        onAccepted: field.accepted()
        Keys.onTabPressed: (event) => {
            event.accepted = true
            field.tabbed()
        }
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        visible: input.text.length === 0
        text: field.placeholder
        color: "#756C63"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
    }
}
