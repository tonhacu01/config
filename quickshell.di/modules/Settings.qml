import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property bool isOpen: false

    IpcHandler {
        target: "settings"

        function toggle(): void {
            root.isOpen = !root.isOpen
        }

        function open(): void {
            root.isOpen = true
        }

        function close(): void {
            root.isOpen = false
        }
    }

    LazyLoader {
        active: root.isOpen

        FloatingWindow {
            id: window

            title: "Settings"
            implicitWidth: 960
            implicitHeight: 680
            visible: true
            color: "transparent"

            readonly property string uiFont: "SF Pro Display"

            readonly property color bgApp: "#0f0f0f"
            readonly property color bgSidebar: "#121212"
            readonly property color bgCard: "#181818"
            readonly property color bgHover: "#222222"
            readonly property color bgSelected: "#2a2a2a"
            readonly property color accentMint: "#4de4a2"
            readonly property color accentMintDark: "#1a3a2e"
            readonly property color textMain: "#e2e2e2"
            readonly property color textMuted: "#888888"

            component MaterialIcon: Text {
                property string icon: ""
                property color iconColor: window.textMain
                property real sz: 18

                text: icon
                font.family: "Material Symbols Outlined"
                font.pixelSize: sz
                color: iconColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            component MintSwitch: Switch {
                id: control

                implicitWidth: 44
                implicitHeight: 24

                indicator: Rectangle {
                    implicitWidth: 44
                    implicitHeight: 24
                    x: control.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 12
                    color: control.checked ? window.accentMint : "#333333"

                    Rectangle {
                        x: control.checked ? parent.width - width - 3 : 3
                        y: 3
                        width: 18
                        height: 18
                        radius: 9
                        color: control.checked ? "#0f0f0f" : "#888888"

                        Behavior on x {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
                }
            }

            component SettingSlider: ColumnLayout {
                property string label: ""
                property real val: 0
                property string unit: "px"
                property real fromVal: 0
                property real toVal: 200

                Layout.fillWidth: true
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: label
                        color: window.textMain
                        font.family: window.uiFont
                        font.pixelSize: 13
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: Math.round(slider.value) + " " + unit
                        color: window.textMuted
                        font.family: window.uiFont
                        font.pixelSize: 13
                    }
                }

                Slider {
                    id: slider

                    Layout.fillWidth: true
                    from: fromVal
                    to: toVal
                    value: val

                    background: Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: slider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: "#282828"

                        Rectangle {
                            width: slider.visualPosition * parent.width
                            height: parent.height
                            color: window.accentMint
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 14
                        implicitHeight: 14
                        radius: 7
                        color: "#e2e2e2"
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                color: window.bgApp
                radius: 16
                border.color: "#222222"
                border.width: 1
                clip: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 220
                        color: window.bgSidebar

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            Rectangle {
                                Layout.fillWidth: true
                                height: 36
                                color: window.bgCard
                                radius: 10

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 8

                                    MaterialIcon {
                                        icon: "search"
                                        sz: 16
                                        iconColor: window.textMuted
                                    }

                                    TextField {
                                        Layout.fillWidth: true
                                        placeholderText: "Search Settings"
                                        placeholderTextColor: window.textMuted
                                        color: window.textMain
                                        background: null
                                        font.family: window.uiFont
                                        font.pixelSize: 13
                                    }
                                }
                            }

                            ListView {
                                id: navList

                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: 4
                                clip: true

                                model: ListModel {
                                    ListElement { name: "Bar & Island"; icon: "dock" }
                                    ListElement { name: "Clock & Date"; icon: "schedule" }
                                    ListElement { name: "Appearance"; icon: "palette" }
                                    ListElement { name: "Motion"; icon: "animation" }
                                    ListElement { name: "Launcher"; icon: "search" }
                                    ListElement { name: "Notifications"; icon: "notifications" }
                                    ListElement { name: "Control Center"; icon: "tune" }
                                    ListElement { name: "Lock Screen"; icon: "lock" }
                                    ListElement { name: "System"; icon: "settings" }
                                }

                                delegate: ItemDelegate {
                                    width: navList.width
                                    height: 40
                                    highlighted: ListView.isCurrentItem

                                    background: Rectangle {
                                        color: parent.highlighted
                                            ? window.bgSelected
                                            : (parent.hovered ? window.bgHover : "transparent")
                                        radius: 12
                                    }

                                    contentItem: RowLayout {
                                        spacing: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10

                                        Rectangle {
                                            width: 26
                                            height: 26
                                            radius: 13
                                            color: parent.parent.highlighted
                                                ? window.accentMint
                                                : "transparent"

                                            MaterialIcon {
                                                anchors.centerIn: parent
                                                icon: model.icon
                                                sz: 16
                                                iconColor: parent.parent.parent.highlighted
                                                    ? window.bgApp
                                                    : window.accentMint
                                            }
                                        }

                                        Text {
                                            text: model.name
                                            color: parent.parent.highlighted
                                                ? window.textMain
                                                : window.textMuted
                                            font.family: window.uiFont
                                            font.pixelSize: 13
                                            font.bold: parent.parent.highlighted
                                        }
                                    }

                                    onClicked: navList.currentIndex = index
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: window.bgApp

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 16

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: window.bgCard

                                    MaterialIcon {
                                        anchors.centerIn: parent
                                        icon: "arrow_back"
                                        sz: 16
                                        iconColor: window.textMuted
                                    }
                                }

                                Rectangle {
                                    width: 28
                                    height: 28
                                    radius: 14
                                    color: window.bgCard

                                    MaterialIcon {
                                        anchors.centerIn: parent
                                        icon: "arrow_forward"
                                        sz: 16
                                        iconColor: window.textMuted
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 120
                                color: window.bgCard
                                radius: 16

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Rectangle {
                                        Layout.alignment: Qt.AlignHCenter
                                        width: 44
                                        height: 44
                                        radius: 22
                                        color: window.accentMintDark

                                        MaterialIcon {
                                            anchors.centerIn: parent
                                            icon: "dock"
                                            sz: 22
                                            iconColor: window.accentMint
                                        }
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Bar & Island"
                                        color: window.textMain
                                        font.family: window.uiFont
                                        font.pixelSize: 16
                                        font.bold: true
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Shape and size of the island, the notch, and the Game Mode bar."
                                        color: window.textMuted
                                        font.family: window.uiFont
                                        font.pixelSize: 12
                                    }
                                }
                            }

                            ScrollView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                contentWidth: availableWidth
                                clip: true

                                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                                ColumnLayout {
                                    width: parent.width
                                    spacing: 16

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            text: "Notch mode"
                                            color: window.textMain
                                            font.family: window.uiFont
                                            font.pixelSize: 13
                                            Layout.fillWidth: true
                                        }

                                        MintSwitch {
                                            checked: false
                                        }
                                    }

                                    SettingSlider {
                                        label: "Bar height"
                                        val: 33
                                    }

                                    SettingSlider {
                                        label: "Collapsed width"
                                        val: 96
                                    }

                                    SettingSlider {
                                        label: "Expanded height"
                                        val: 125
                                    }

                                    SettingSlider {
                                        label: "Gap from screen edge"
                                        val: 11
                                    }

                                    SettingSlider {
                                        label: "Inner padding"
                                        val: 3
                                    }

                                    SettingSlider {
                                        label: "Corner radius"
                                        val: 20
                                    }

                                    SettingSlider {
                                        label: "Corner radius (expanded)"
                                        val: 31
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            text: "Status circle (battery and Wi-Fi)"
                                            color: window.textMain
                                            font.family: window.uiFont
                                            font.pixelSize: 13
                                            Layout.fillWidth: true
                                        }

                                        MintSwitch {
                                            checked: true
                                        }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true

                                        Text {
                                            text: "Album art circle while a player is open"
                                            color: window.textMain
                                            font.family: window.uiFont
                                            font.pixelSize: 13
                                            Layout.fillWidth: true
                                        }

                                        MintSwitch {
                                            checked: true
                                        }
                                    }

                                    SettingSlider {
                                        label: "Stage lift on hover"
                                        val: 7
                                    }

                                    Text {
                                        text: "Game mode"
                                        color: window.textMuted
                                        font.family: window.uiFont
                                        font.pixelSize: 11
                                        font.bold: true
                                        Layout.topMargin: 8
                                    }
                                    
                                    SettingSlider {
                                        label: "Cluster gap"
                                        val: 173
                                    }

                                    SettingSlider {
                                        label: "Bar height"
                                        val: SettingsState.barHeight

                                        onValChanged: SettingsState.barHeight = val
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}