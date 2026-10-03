import QtQuick
import QtQuick.Shapes
import Quickshell

ShellRoot {
    id: root

    readonly property int radius: 12
    readonly property int scaleFactor: 4
    readonly property color cornerColor: "#000000"

    // =========================================================
    // TOP-LEFT chuẩn
    // =========================================================
    component CornerShape: Shape {
        width: root.radius
        height: root.radius

        ShapePath {
            fillColor: root.cornerColor
            strokeWidth: 0

            // Góc ngoài cùng
            startX: 0
            startY: root.radius

            // Đi lên theo cạnh trái
            PathLine {
                x: 0
                y: 0
            }

            // Đi sang phải theo cạnh trên
            PathLine {
                x: root.radius
                y: 0
            }

            // Cung tròn quay về góc dưới-trái
            PathArc {
                x: 0
                y: root.radius

                radiusX: root.radius
                radiusY: root.radius

                direction: PathArc.Counterclockwise
            }
        }
    }

    // =========================================================
    // TOP-LEFT
    // =========================================================
    PanelWindow {
        width: root.radius
        height: root.radius

        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        anchors.top: true
        anchors.left: true

        CornerShape {}
    }

    // =========================================================
    // TOP-RIGHT
    // =========================================================
    PanelWindow {
        width: root.radius
        height: root.radius

        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        anchors.top: true
        anchors.right: true

        CornerShape {
            transform: Rotation {
                origin.x: root.radius / 2
                origin.y: root.radius / 2
                angle: 90
            }
        }
    }

    // =========================================================
    // BOTTOM-RIGHT
    // =========================================================
    PanelWindow {
        width: root.radius
        height: root.radius

        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        anchors.bottom: true
        anchors.right: true

        CornerShape {
            transform: Rotation {
                origin.x: root.radius / 2
                origin.y: root.radius / 2
                angle: 180
            }
        }
    }

    // =========================================================
    // BOTTOM-LEFT
    // =========================================================
    PanelWindow {
        width: root.radius
        height: root.radius

        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        anchors.bottom: true
        anchors.left: true

        CornerShape {
            transform: Rotation {
                origin.x: root.radius / 2
                origin.y: root.radius / 2
                angle: 270
            }
        }
    }
}
