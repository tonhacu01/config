// Qt-group
import QtQuick
import QtQuick.Effects

// Quickshell-group
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

// Import things-group
import "./modules" as Modules
import "./ScreenCorners"
import "./modules"

ShellRoot {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: reserve

            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 45
            color: "transparent"

            exclusionMode: ExclusionMode.Normal
            exclusiveZone: 45

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overlay

            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 1000
            color: "transparent"

            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            HyprlandWindow.opacity:
                Hyprland.focusedWorkspace?.hasFullscreen ? 0 : 1

            Behavior on HyprlandWindow.opacity {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }

            mask: Region {
                Region {
                    item: mediaPill
                }

                Region {
                    item: island
                }

                Region {
                    item: statusPill
                }
            }

            ScreenCorners {}

            Settings {}

            Modules.Island {
                id: island
            }

           Modules.MediaPill {
                id: mediaPill

                anchors {
                    top: island.top
                    right: island.left
                    rightMargin: 10
                }
            }

            Modules.StatusPill {
                id: statusPill

                anchors {
                    top: island.top
                    left: island.right
                    leftMargin: 9
                }
            }

        }
    }
}
