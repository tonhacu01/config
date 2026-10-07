import QtQuick
import QtQuick.Effects
import qs.theme

RectangularShadow {
    id: shadow

    anchors.fill: parent
    anchors.margins: -4

    radius: parent.radius ? parent.radius : 15

    blur: Theme.shadowBlur
    spread: Theme.shadowSpread
    offset: Theme.shadowOffset
    color: Theme.shadowColor
}