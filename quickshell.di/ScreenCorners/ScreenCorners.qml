import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    property int rounding: 10

    function isFullscreenOn(screen) {
        const monitor = Hyprland.monitorFor(screen)
        if (!monitor)
            return false

        const workspaces = Hyprland.workspaces.values.filter(
            ws => ws.monitor && ws.monitor.name === monitor.name
        )

        return workspaces.some(ws =>
            ws.active &&
            ws.toplevels.values.some(window =>
                window.wayland?.fullscreen === true
            )
        )
    }

    component Corner: PanelWindow {
        id: corner

        required property int cornerType
        required property var targetScreen

        screen: targetScreen

        exclusionMode: ExclusionMode.Ignore

        WlrLayershell.namespace: "quickshell:screenCorners"
        WlrLayershell.layer: WlrLayer.Overlay

        color: "transparent"

        visible: !root.isFullscreenOn(targetScreen)

        implicitWidth: root.rounding
        implicitHeight: root.rounding

        anchors {
            top: cornerType === 0 || cornerType === 1
            bottom: cornerType === 2 || cornerType === 3
            left: cornerType === 0 || cornerType === 2
            right: cornerType === 1 || cornerType === 3
        }

        Canvas {
            anchors.fill: parent

            onPaint: {
                const ctx = getContext("2d")
                const r = width

                ctx.clearRect(0, 0, width, height)
                ctx.fillStyle = "black"
                ctx.beginPath()

                if (cornerType === 0) {
                    ctx.moveTo(0, r)
                    ctx.arc(r, r, r, Math.PI, 1.5 * Math.PI)
                    ctx.lineTo(0, 0)
                } else if (cornerType === 1) {
                    ctx.moveTo(0, 0)
                    ctx.lineTo(r, 0)
                    ctx.arc(0, r, r, 1.5 * Math.PI, 2 * Math.PI)
                    ctx.lineTo(r, 0)
                } else if (cornerType === 2) {
                    ctx.moveTo(0, 0)
                    ctx.lineTo(0, r)
                    ctx.arc(r, 0, r, 0.5 * Math.PI, Math.PI)
                    ctx.lineTo(0, r)
                } else {
                    ctx.moveTo(0, r)
                    ctx.lineTo(r, r)
                    ctx.lineTo(r, 0)
                    ctx.arc(0, 0, r, 0, Math.PI / 2, false)
                    ctx.lineTo(0, r)
                }

                ctx.closePath()
                ctx.fill()
            }

            Component.onCompleted: requestPaint()
        }
    }

    Variants {
        model: Quickshell.screens

        Scope {
            required property var modelData

            Corner {
                targetScreen: modelData
                cornerType: 0
            }

            Corner {
                targetScreen: modelData
                cornerType: 1
            }

            Corner {
                targetScreen: modelData
                cornerType: 2
            }

            Corner {
                targetScreen: modelData
                cornerType: 3
            }
        }
    }
}