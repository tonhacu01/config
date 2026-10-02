import QtQuick
import QtQuick.Effects

RectangularShadow {
    id: shadow

    anchors.fill: parent
    anchors.margins: -4

    radius: parent.radius ? parent.radius : 15

    // Blur specs
    blur: 20
    spread: 0.25
    offset: 3
    color: Qt.rgba(0, 0, 0, 0.35)
}