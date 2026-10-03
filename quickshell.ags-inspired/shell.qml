import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Services.Mpris

import qs.AppLauncher
import qs.ScreenCorners
import qs.Wallpaper
import qs.modules
import "./theme-switcher"

PanelWindow {
    id: root

    anchors {
        top: true
    }

    margins {
        top: 8
    }

    // ================================================================
    // WINDOW
    // ================================================================

    // +20px để tạo vùng đệm cho shadow
    width: mainPill.width + 20
    height: mainPill.height + 20
    color: "transparent"

    // ================================================================
    // MAIN PILL
    // ================================================================

    Rectangle {
        id: mainPill

        anchors.centerIn: parent

        width: 440
        height: 36
        radius: height / 2

        color: Theme.bgBase
        border.color: Theme.bgBorder
        border.width: 1

        // ============================================================
        // SHADOW
        // ============================================================

        RectangularShadow {
            anchors.fill: parent

            radius: parent.radius
            blur: 12
            spread: 1
            offset: Qt.vector2d(0, 3)
            color: Qt.rgba(0, 0, 0, 0.45)

            cached: true
            z: -1
        }

        // ============================================================
        // 1. CLOCK
        // ============================================================

        Text {
            id: clockText

            anchors {
                left: parent.left
                leftMargin: 18
                verticalCenter: parent.verticalCenter
            }

            text: Qt.formatDateTime(new Date(), "hh:mm")
            color: Theme.textPrimary

            font.pixelSize: 14
            font.bold: true
            font.family: "SF Pro Display"

            Timer {
                interval: 1000
                running: true
                repeat: true

                onTriggered: {
                    clockText.text =
                        Qt.formatDateTime(new Date(), "hh:mm")
                }
            }
        }

        // ============================================================
        // 2. MEDIA / PLAYER STATUS
        // ============================================================

        Text {
            id: mediaText

            anchors {
                left: clockText.right
                leftMargin: 30
                verticalCenter: parent.verticalCenter
            }

            property var activePlayer:
                Mpris.players.values[0]

            text: activePlayer && activePlayer.trackTitle
                  ? activePlayer.trackTitle
                  : "Nothing playing"

            color: Theme.textSecondary

            font.pixelSize: 14
            font.weight: Font.Medium
            font.family: "SF Pro Display"

            elide: Text.ElideRight
            width: 120
        }

        // ============================================================
        // 3. WORKSPACES
        // ============================================================

        Item {
            id: workspaceArea

            anchors {
                left: mediaText.right
                leftMargin: 8
                verticalCenter: parent.verticalCenter
            }

            width: 20 * 6 + 2 * 5
            height: 22

            Item {
                id: wsContainer

                anchors.fill: parent

                property int activeWs:
                    Hyprland.focusedMonitor?.activeWorkspace?.id ?? 2

                property bool isDragging:
                    dragArea.pressed

                property int tempWs:
                    activeWs

                // ====================================================
                // ACTIVE CAPSULE
                // ====================================================

                Rectangle {
                    id: activeCapsule

                    width: 26
                    height: 20
                    radius: height / 2

                    property int currentWs:
                        wsContainer.isDragging
                        ? wsContainer.tempWs
                        : wsContainer.activeWs

                    x: (currentWs - 1) * 22 - 3
                    y: (parent.height - height) / 2

                    // Gradient xanh:
                    // mint -> aqua -> cyan
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: Theme.accentGreen
                        }

                        GradientStop {
                            position: 0.5
                            color: Theme.accentPrimary
                        }

                        GradientStop {
                            position: 1.0
                            color: Theme.accentCyan
                        }
                    }

                    Behavior on x {
                        SpringAnimation {
                            spring: 4.5
                            damping: 0.26
                            epsilon: 0.25
                        }
                    }
                }

                // ====================================================
                // WORKSPACE NUMBERS
                // ====================================================

                Row {
                    id: numbersRow

                    anchors.fill: parent
                    spacing: 2

                    Repeater {
                        model: [1, 2, 3, 4, 5, 6]

                        Item {
                            id: wsItem

                            required property int modelData

                            width: 20
                            height: 22

                            property bool isSelected:
                                activeCapsule.currentWs === modelData

                            Text {
                                anchors.centerIn: parent

                                text: parent.modelData

                                color:
                                    wsItem.isSelected
                                    ? Theme.bgBase
                                    : Theme.textMuted

                                font.pixelSize: 13
                                font.bold: true
                                font.family: "SF Pro Display"

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                            }
                        }
                    }
                }

                // ====================================================
                // DRAG AREA
                // ====================================================

                MouseArea {
                    id: dragArea

                    anchors.fill: parent

                    cursorShape: Qt.PointingHandCursor
                    preventStealing: true

                    function getTargetWorkspace(mouseX) {
                        var calculated =
                            Math.floor(mouseX / 22) + 1

                        return Math.max(
                            1,
                            Math.min(6, calculated)
                        )
                    }

                    onPressed: mouse => {
                        wsContainer.tempWs =
                            getTargetWorkspace(mouse.x)
                    }

                    onPositionChanged: mouse => {
                        if (pressed) {
                            var target =
                                getTargetWorkspace(mouse.x)

                            if (
                                wsContainer.tempWs !== target
                            ) {
                                wsContainer.tempWs = target

                                Hyprland.dispatch(
                                    `hl.dsp.focus({ workspace = "${target}" })`
                                )
                            }
                        }
                    }

                    onReleased: {
                        Hyprland.dispatch(
                            `hl.dsp.focus({ workspace = "${wsContainer.tempWs}" })`
                        )
                    }
                }
            }
        }

        // ============================================================
        // 4. STATUS RIGHT
        // ============================================================

        RowLayout {
            id: statusRow

            anchors {
                right: parent.right
                rightMargin: 12
                verticalCenter: parent.verticalCenter
            }

            spacing: 10

            // ========================================================
            // NETWORK / WIFI
            // ========================================================

            Text {
                text: "signal_wifi_4_bar"

                color: "#ffffff"

                font.pixelSize: 14
                font.family: "Material Symbols Sharp"

                Layout.alignment: Qt.AlignVCenter
            }

            // ========================================================
            // BATTERY BADGE
            // ========================================================

            Rectangle {
                id: statusBadge

                implicitWidth:
                    batText.implicitWidth + 12

                height: 20
                radius: height / 2

                color: Theme.accentGreen

                property var device:
                    UPower.displayDevice

                property int batPercent:
                    device &&
                    device.percentage !== undefined
                    ? Math.round(device.percentage * 100)
                    : 80

                Text {
                    id: batText

                    anchors.centerIn: parent

                    text: "80"

                    color: "#0d1315"

                    font.pixelSize: 12
                    font.bold: true
                    font.family: "SF Pro Display"
                }
            }
        }
    }

    // ================================================================
    // EXTERNAL COMPONENTS
    // ================================================================

    AppLauncher {}
    ScreenCorners {}
    WallpaperManager {}
    Control {}
    Notifications {}
    ThemeSwitcher {}
}