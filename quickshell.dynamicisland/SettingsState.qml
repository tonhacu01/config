pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool notchMode: false

    property real barHeight: 33
    property real collapsedWidth: 96
    property real expandedHeight: 125
    property real screenGap: 11
    property real innerPadding: 3
    property real cornerRadius: 20
    property real expandedCornerRadius: 31

    property bool statusCircle: true
    property bool albumArtCircle: true

    property real stageLift: 7

    property real gameModeBarHeight: 47
    property real gameModeClusterGap: 173
}