import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import qs

PanelWindow {

    id: root

    // ========================================================
    // 1. CURRENT DATE
    // ========================================================

    property date currentDate: new Date()

    property int currentDay: currentDate.getDate()
    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()

    property var monthNames: [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]

    // Calendar model được tạo tự động từ ngày hiện tại
    property var calendarDays: []

    function rebuildCalendar() {
        var days = []

        var firstDay = new Date(
            currentYear,
            currentMonth,
            1
        ).getDay()

        var daysInMonth = new Date(
            currentYear,
            currentMonth + 1,
            0
        ).getDate()

        var daysInPreviousMonth = new Date(
            currentYear,
            currentMonth,
            0
        ).getDate()

        // ---------------------------------------------
        // Previous month
        // ---------------------------------------------

        for (var i = firstDay - 1; i >= 0; i--) {
            days.push({
                d: daysInPreviousMonth - i,
                cur: false,
                sel: false
            })
        }

        // ---------------------------------------------
        // Current month
        // ---------------------------------------------

        for (var d = 1; d <= daysInMonth; d++) {
            days.push({
                d: d,
                cur: true,
                sel: d === currentDay
            })
        }

        // ---------------------------------------------
        // Next month
        // ---------------------------------------------

        var remaining = 42 - days.length

        for (var n = 1; n <= remaining; n++) {
            days.push({
                d: n,
                cur: false,
                sel: false
            })
        }

        calendarDays = days
    }

    // Cập nhật khi qua ngày mới
    Timer {
        interval: 30000
        running: true
        repeat: true

        onTriggered: {
            var now = new Date()

            if (
                now.getDate() !== root.currentDay ||
                now.getMonth() !== root.currentMonth ||
                now.getFullYear() !== root.currentYear
            ) {
                root.currentDate = now
                root.currentDay = now.getDate()
                root.currentMonth = now.getMonth()
                root.currentYear = now.getFullYear()

                root.rebuildCalendar()
            }
        }
    }

    Component.onCompleted: {
        rebuildCalendar()
    }

    // ========================================================
    // 2. IPC
    // ========================================================

    IpcHandler {
        target: "controlcenter"

        function toggle() {
            root.visible = !root.visible
        }

        function open() {
            root.visible = true
        }

        function close() {
            root.visible = false
        }
    }

    visible: false

    // ========================================================
    // 3. WINDOW
    // ========================================================

    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "controlcenter"

    anchors {
        top: true
        bottom: true
        left: true
    }

    margins {
        top: 0
        bottom: 0
        left: 0
    }

    width: 380

    color: "transparent"

    // ========================================================
    // MAIN CONTAINER
    // ========================================================

    Item {
        anchors.fill: parent
        anchors.margins: 12

        // ====================================================
        // MAIN PANEL
        // ====================================================

        Rectangle {
            id: mainPanel

            anchors.fill: parent

            radius: 20

            color: Colors.bg0
            border.color: "#182326"
            border.width: 1

            // =================================================
            // CONTENT
            // =================================================

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 14

                // ========================================================
                // 1. CALENDAR CARD
                // ========================================================

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 320

                    radius: 14
                    color: Colors.bg1

                    // ---------------------------------------------
                    // SHADOW
                    // ---------------------------------------------

                    RectangularShadow {
                        anchors.fill: parent

                        radius: 14
                        blur: 14
                        spread: 1
                        offset: Qt.vector2d(0, 3)

                        color: Qt.rgba(0, 0, 0, 0.35)

                        cached: true
                        z: -1
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 10

                        Text {
                            text: "Calendar"

                            color: "#ffffff"

                            font.pixelSize: 14
                            font.bold: true
                            font.family: "SF Pro Display"
                        }

                        // =================================================
                        // MONTH / YEAR SELECTOR
                        // =================================================

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                Layout.fillWidth: true

                                height: 32
                                radius: 8

                                color: Colors.bg2
                                RowLayout {
                                    anchors.fill: parent

                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10

                                    Text {
                                        text: "◀"

                                        color: "#4a5b61"
                                        font.pixelSize: 9
                                    }

                                    Text {
                                        text: root.monthNames[root.currentMonth]

                                        color: "#ffffff"

                                        font.pixelSize: 13
                                        font.bold: true
                                        font.family: "SF Pro Display"

                                        Layout.alignment: Qt.AlignCenter
                                        Layout.fillWidth: true

                                        horizontalAlignment:
                                            Text.AlignHCenter
                                    }

                                    Text {
                                        text: "▶"

                                        color: "#4a5b61"
                                        font.pixelSize: 9
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true

                                height: 32
                                radius: 8

                                color: Colors.bg2

                                RowLayout {
                                    anchors.fill: parent

                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10

                                    Text {
                                        text: "◀"

                                        color: "#4a5b61"
                                        font.pixelSize: 9
                                    }

                                    Text {
                                        text: root.currentYear

                                        color: "#ffffff"

                                        font.pixelSize: 13
                                        font.bold: true
                                        font.family: "SF Pro Display"

                                        Layout.alignment: Qt.AlignCenter
                                        Layout.fillWidth: true

                                        horizontalAlignment:
                                            Text.AlignHCenter
                                    }

                                    Text {
                                        text: "▶"

                                        color: "#4a5b61"
                                        font.pixelSize: 9
                                    }
                                }
                            }
                        }

                        // =================================================
                        // DAYS OF WEEK
                        // =================================================

                        Row {
                            Layout.fillWidth: true
                            spacing: 0

                            Repeater {
                                model: [
                                    "Sun",
                                    "Mon",
                                    "Tue",
                                    "Wed",
                                    "Thu",
                                    "Fri",
                                    "Sat"
                                ]

                                Item {
                                    width: parent.width / 7
                                    height: 22

                                    Text {
                                        anchors.centerIn: parent

                                        text: modelData

                                        color: "#4a5f66"

                                        font.pixelSize: 12
                                        font.family: "SF Pro Display"
                                    }
                                }
                            }
                        }

                        // =================================================
                        // CALENDAR GRID
                        // =================================================

                        Grid {
                            Layout.fillWidth: true

                            columns: 7
                            spacing: 0

                            Repeater {
                                model: root.calendarDays

                                Item {
                                    width: parent.width / 7
                                    height: 30

                                    Rectangle {
                                        anchors.centerIn: parent

                                        width: 28
                                        height: 28

                                        radius: 15

                                        color: modelData.sel
                                               ? Colors.aqua
                                               : "transparent"

                                        visible: modelData.sel
                                    }

                                    Text {
                                        anchors.centerIn: parent

                                        text: modelData.d

                                        color: modelData.sel
                                               ? "#0b1113"
                                               : (
                                                   modelData.cur
                                                   ? "#ffffff"
                                                   : "#222f33"
                                               )

                                        font.pixelSize: 13

                                        font.bold:
                                            modelData.sel

                                        font.family:
                                            "SF Pro Display"
                                    }
                                }
                            }
                        }
                    }
                }

                // ========================================================
                // 2. POMODORO CARD
                // ========================================================

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 250

                    radius: 14
                    color: Colors.bg1

                    // ---------------------------------------------
                    // SHADOW
                    // ---------------------------------------------

                    RectangularShadow {
                        anchors.fill: parent

                        radius: 14
                        blur: 14
                        spread: 1
                        offset: Qt.vector2d(0, 3)

                        color: Qt.rgba(0, 0, 0, 0.35)

                        cached: true
                        z: -1
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 8

                        Text {
                            text: "Pomodoro"

                            color: "#ffffff"

                            font.pixelSize: 14
                            font.bold: true
                            font.family: "SF Pro Display"
                        }

                        Rectangle {
                            width: 56
                            height: 20

                            radius: 10
                            color: "#162023"

                            Text {
                                anchors.centerIn: parent

                                text: "Ready"

                                color: "#3a4d53"

                                font.pixelSize: 11
                                font.family: "SF Pro Display"
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignCenter

                            text: "25:00"

                            color: "#ffffff"

                            font.pixelSize: 52
                            font.bold: true
                            font.family: "SF Pro Display"
                        }

                        Row {
                            Layout.alignment: Qt.AlignCenter

                            spacing: 8

                            Repeater {
                                model: 4

                                Rectangle {
                                    width: 6
                                    height: 6

                                    radius: 3

                                    color: "#1b272a"
                                }
                            }
                        }

                        Item {
                            Layout.fillHeight: true
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignCenter

                            width: 80
                            height: 32

                            radius: 16

                            color: Colors.aqua

                            Text {
                                anchors.centerIn: parent

                                text: "Start"

                                color: "#0b1113"

                                font.pixelSize: 13
                                font.bold: true
                                font.family: "SF Pro Display"
                            }

                            MouseArea {
                                anchors.fill: parent

                                cursorShape:
                                    Qt.PointingHandCursor
                            }
                        }
                    }
                }

                // ========================================================
                // 3. TASKS CARD
                // ========================================================

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    radius: 14
                    color: Colors.bg1

                    // ---------------------------------------------
                    // SHADOW
                    // ---------------------------------------------

                    RectangularShadow {
                        anchors.fill: parent

                        radius: 14
                        blur: 14
                        spread: 1
                        offset: Qt.vector2d(0, 3)

                        color: Qt.rgba(0, 0, 0, 0.35)

                        cached: true
                        z: -1
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 12

                        Text {
                            text: "Tasks"

                            color: "#ffffff"

                            font.pixelSize: 14
                            font.bold: true
                            font.family: "SF Pro Display"
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 10

                            Rectangle {
                                Layout.fillWidth: true

                                height: 36
                                radius: 15

                                color: Colors.bg2

                                TextInput {
                                    anchors.fill: parent

                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12

                                    verticalAlignment:
                                        Text.AlignVCenter

                                    color: "#ffffff"

                                    font.pixelSize: 13
                                    font.family: "SF Pro Display"

                                    Text {
                                        anchors.fill: parent

                                        verticalAlignment:
                                            Text.AlignVCenter

                                        text: "Add a task..."

                                        color: "#4a5b61"

                                        font.pixelSize: 13
                                        font.family: "SF Pro Display"

                                        visible: !parent.text
                                    }
                                }
                            }

                            Rectangle {
                                width: 36
                                height: 36

                                radius: 15

                                color: Colors.aqua

                                Text {
                                    anchors.centerIn: parent

                                    text: "+"

                                    color: "#0b1113"

                                    font.pixelSize: 20
                                    font.bold: true
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    cursorShape:
                                        Qt.PointingHandCursor
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            Text {
                                anchors.centerIn: parent

                                text: "No tasks yet"

                                color: "#2a373b"

                                font.pixelSize: 13
                                font.family: "SF Pro Display"
                            }
                        }

                        Text {
                            text: "0 tasks remaining"

                            color: "#222f33"

                            font.pixelSize: 12
                            font.family: "SF Pro Display"
                        }
                    }
                }
            }
        }
    }
}