pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // --------- palette ---------
    // Colours come from colors.json, which apply-colors.sh writes from the same
    // Waybar palette the rest of your ~/.config/colorschemes pipeline uses.
    //
    // watchChanges plus onFileChanged does the whole theme switch. The switcher
    // rewrites colors.json, FileView notices, and every binding below updates.
    // No restart, no reload, no flicker.
    //
    // The values below are Ariadne. They apply when colors.json goes missing.
    FileView {
        path: `${Quickshell.env("HOME")}/.config/quickshell/colors.json`
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: palette

            // Which theme these colours came from, so the bar names the theme.
            property string name: "unknown"

            // bg0 runs darkest. Each step up sits one shade lighter.
            property string bg0: "#040e0d"
            property string bg1: "#0a1816"
            property string bg2: "#0f211f"
            property string bg3: "#152a26"
            property string bg4: "#1d3631"

            property string fg: "#f5e2c5"

            property string red: "#ff6048"
            property string orange: "#ffa478"
            property string yellow: "#f5cd5b"
            property string green: "#7ad9a8"
            property string aqua: "#3dd1b0"
            property string blue: "#5fc8d4"
            property string purple: "#e89aa8"
            property string grey0: "#3a1a35"
            property string grey1: "#5a4d3e"
            property string grey2: "#c4b09a"
        }
    }

    // --------- colours ---------
    readonly property string name: palette.name

    // Bar names on the left, palette names on the right.
    // Remap a colour here and every module picks up the change.
    //
    // bg is the strip behind the modules. Transparent leaves the modules as
    // separate islands on your wallpaper. Set bg to palette.bg0 for a solid bar.
    property color bg: "transparent"

    readonly property color pill: palette.bg1         // body of a module
    readonly property color pillIcon: palette.bg3     // icon square, one shade lighter
    readonly property color text: palette.fg          // every piece of text

    readonly property color red: palette.red
    readonly property color orange: palette.orange
    readonly property color yellow: palette.yellow
    readonly property color green: palette.green
    readonly property color cyan: palette.aqua
    readonly property color teal: palette.blue
    readonly property color blue: palette.blue
    readonly property color purple: palette.purple
    readonly property color magenta: palette.purple
    readonly property color pink: palette.purple

    // Marks the active workspace.
    readonly property color accent: cyan

    // --------- sizes ---------
    property int barHeight: 50    // total height of the bar
    property int moduleHeight: 30 // height of every module
    property int spacing: 8          // gap between modules and screen edges
    property int radius: moduleHeight / 2        // corner rounding
    property int margin: 13         // how far the bar floats off the screen edges

    // --------- shadows ---------
    // A shadow gets clipped at the window edge.
    // Give the window shadowRoom above and below the modules.
    // Keep shadowRoom above blur plus offset, or the shadow ends in a straight line.
    property int shadowRoom: 24
    property real shadowBlur: 16
    property real shadowSpread: 1
    property real shadowOffset: 3
    property color shadowColor: Qt.rgba(0, 0, 0, 0.45)

    // --------- fonts ---------
    // The font for every word on the bar.
    property string font: "Iosevka Nerd Font"
    property real letterSpacing: 0

    // The font for icons.
    //
    // Material Symbols works by ligature. You write the icon name, like "wifi"
    // or "battery_full". The font swaps those letters for the icon.
    //
    // Keep this a Material Symbols family. Any other font draws the word "wifi".
    // Browse names at https://fonts.google.com/icons
    property string iconFont: "Material Symbols Rounded"

    // Material Symbols ships as one variable font.
    // Four axes shape every icon on the bar:
    //   FILL  0 outlined, 1 solid. Values between work.
    //   wght  stroke thickness, 100 thin to 700 bold
    //   GRAD  emphasis tweak, -25 to 200
    //   opsz  the size you draw at, so the font tunes proportions
    property var iconAxes: ({
        "FILL": 0,
        "wght": 700,
        "GRAD": 0,
        "opsz": 20
    })

    property real textSize: 15
    property int iconSize: 16
}