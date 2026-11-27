import QtQuick

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#191617"

    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    property var sessionNames: []

    // Wallpaper, slightly darkened (install-theme.sh puts background.jpeg in place)
    Image {
        anchors.fill: parent
        source: "background.jpeg"
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#191617"
        opacity: 0.55
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorText.visible = true
            password.text = ""
            password.focusInput()
        }
    }

    // Collect the session names so you can cycle through them
    Repeater {
        model: sessionModel
        delegate: Item {
            Component.onCompleted: {
                var names = root.sessionNames.slice()
                names[index] = model.name
                root.sessionNames = names
            }
        }
    }

    function doLogin() {
        errorText.visible = false
        sddm.login(user.text, password.text, root.sessionIndex)
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            clock.text = Qt.formatTime(now, "hh:mm")
            dateText.text = Qt.formatDate(now, "dddd, dd.MM.yyyy")
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "[ BUNKER SYSTEM // LOGIN ]"
            color: "#756C63"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 20
        }

        Text {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#756C63"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 90
        }

        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#756C63"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
        }

        Item {
            width: 1
            height: 24
        }

        Field {
            id: user
            anchors.horizontalCenter: parent.horizontalCenter
            placeholder: "[ USER ]"
            text: userModel.lastUser
            onAccepted: password.focusInput()
            onTabbed: password.focusInput()
        }

        Field {
            id: password
            anchors.horizontalCenter: parent.horizontalCenter
            placeholder: "[ PASSWORD ]"
            echoMode: TextInput.Password
            onAccepted: root.doLogin()
            onTabbed: user.focusInput()
        }

        Text {
            id: errorText
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
            text: "[ ACCESS DENIED ]"
            color: "#E04040"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "[ SESSION: " + (root.sessionNames[root.sessionIndex] || "?") + " ]"
            color: "#756C63"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13

            MouseArea {
                anchors.fill: parent
                onClicked: root.sessionIndex = (root.sessionIndex + 1) % Math.max(1, root.sessionNames.length)
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 48
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Tile {
            label: "REBOOT"
            visible: sddm.canReboot
            onClicked: sddm.reboot()
        }

        Tile {
            label: "SHUTDOWN"
            visible: sddm.canPowerOff
            onClicked: sddm.powerOff()
        }
    }

    Component.onCompleted: {
        if (user.text.length > 0)
            password.focusInput()
        else
            user.focusInput()
    }
}
