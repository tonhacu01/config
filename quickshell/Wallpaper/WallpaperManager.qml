import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects


Scope {
    id: root

    property var theme: DefaultTheme {}
    property string font: "SF Pro Display"

    property string searchText: ""
    property string previewPath: ""

    property int selectedIndex: 0

    property bool appearanceSelected: false
    property string appearanceMode: "dark"

    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            wallpaperPanel.visible =
                !wallpaperPanel.visible

            if (wallpaperPanel.visible) {
                root.searchText = ""
                root.previewPath = ""
                root.selectedIndex = 0

                root.appearanceSelected = false
                root.appearanceMode = "dark"

                searchInput.text = ""

                if (
                    WallpaperService.wallpapers.length === 0
                ) {
                    WallpaperService.rescan()
                }
            }
        }
    }

    property var filteredWallpapers: {
        const q =
            root.searchText.toLowerCase()

        if (q === "")
            return WallpaperService.wallpapers

        return WallpaperService.wallpapers.filter(
            p => {
                const name =
                    p.split("/").pop().toLowerCase()

                return name.includes(q)
            }
        )
    }

    PanelWindow {
        id: wallpaperPanel

        visible: false

        focusable: true

        color: "transparent"

        WlrLayershell.layer:
            WlrLayer.Overlay

        WlrLayershell.keyboardFocus:
            WlrKeyboardFocus.Exclusive

        WlrLayershell.namespace:
            "quickshell-wallpaper"

        exclusionMode:
            ExclusionMode.Ignore

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        margins {
            top: 70
        }

        Rectangle {
            id: wallpaperBox

            anchors.horizontalCenter:
                parent.horizontalCenter

            anchors.top:
                parent.top

            width: 720
            height: 560

            radius: 25

            color: root.theme.bgBase

            border.color:
                root.theme.bgBorder

            border.width: 1

            layer.enabled: true

            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#000000"
                shadowOpacity: 1
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 0
                shadowBlur: 0.7
                blurMax: 24
            }

            MouseArea {
                anchors.fill: parent

                onClicked: event => {
                    event.accepted = true
                }
            }

            // ====================================================
            // APPEARANCE
            // ====================================================

            Item {
                anchors.fill: parent

                visible:
                    !root.appearanceSelected

                ColumnLayout {
                    anchors.centerIn:
                        parent

                    width: 300

                    spacing: 16

                    Text {
                        Layout.alignment:
                            Qt.AlignHCenter

                        text: "contrast"

                        color:
                            root.theme.accentPrimary

                        font.family:
                            "Material Symbols Rounded"

                        font.pixelSize: 38
                    }

                    Text {
                        Layout.alignment:
                            Qt.AlignHCenter

                        text: "Appearance"

                        color:
                            root.theme.textPrimary

                        font.family:
                            root.font

                        font.pixelSize: 20
                        font.bold: true
                    }

                    Text {
                        Layout.alignment:
                            Qt.AlignHCenter

                        text:
                            "Choose an appearance for your wallpaper theme"

                        color:
                            root.theme.textMuted

                        font.family:
                            root.font

                        font.pixelSize: 11

                        horizontalAlignment:
                            Text.AlignHCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        height: 8
                    }

                    RowLayout {
                        Layout.alignment:
                            Qt.AlignHCenter

                        spacing: 10

                        // ========================================
                        // DARK
                        // ========================================

                        Rectangle {
                            width: 130
                            height: 72
                            radius: 14

                            color:
                                root.appearanceMode === "dark"
                                ? root.theme.bgSelected
                                : root.theme.bgSurface

                            border.color:
                                root.appearanceMode === "dark"
                                ? root.theme.accentPrimary
                                : root.theme.bgBorder

                            border.width:
                                root.appearanceMode === "dark"
                                ? 2
                                : 1

                            ColumnLayout {
                                anchors.centerIn:
                                    parent

                                spacing: 5

                                Text {
                                    Layout.alignment:
                                        Qt.AlignHCenter

                                    text: "dark_mode"

                                    color:
                                        root.theme.textPrimary

                                    font.family:
                                        "Material Symbols Rounded"

                                    font.pixelSize: 23
                                }

                                Text {
                                    Layout.alignment:
                                        Qt.AlignHCenter

                                    text: "Dark"

                                    color:
                                        root.theme.textPrimary

                                    font.family:
                                        root.font

                                    font.pixelSize: 11
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                hoverEnabled: true

                                cursorShape:
                                    Qt.PointingHandCursor

                                onClicked: {
                                    root.appearanceMode = "dark"
                                    root.appearanceSelected = true
                                }
                            }
                        }

                        // ========================================
                        // LIGHT
                        // ========================================

                        Rectangle {
                            width: 130
                            height: 72
                            radius: 14

                            color:
                                root.appearanceMode === "light"
                                ? root.theme.bgSelected
                                : root.theme.bgSurface

                            border.color:
                                root.appearanceMode === "light"
                                ? root.theme.accentPrimary
                                : root.theme.bgBorder

                            border.width:
                                root.appearanceMode === "light"
                                ? 2
                                : 1

                            ColumnLayout {
                                anchors.centerIn:
                                    parent

                                spacing: 5

                                Text {
                                    Layout.alignment:
                                        Qt.AlignHCenter

                                    text: "light_mode"

                                    color:
                                        root.theme.textPrimary

                                    font.family:
                                        "Material Symbols Rounded"

                                    font.pixelSize: 23
                                }

                                Text {
                                    Layout.alignment:
                                        Qt.AlignHCenter

                                    text: "Light"

                                    color:
                                        root.theme.textPrimary

                                    font.family:
                                        root.font

                                    font.pixelSize: 11
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                hoverEnabled: true

                                cursorShape:
                                    Qt.PointingHandCursor

                                onClicked: {
                                    root.appearanceMode = "light"
                                    root.appearanceSelected = true
                                }
                            }
                        }
                    }
                }
            }

            // ====================================================
            // WALLPAPER LIST
            // ====================================================

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16

                spacing: 12

                visible:
                    root.appearanceSelected

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14

                        color:
                            backHover.containsMouse
                            ? root.theme.bgHover
                            : "transparent"

                        Text {
                            anchors.centerIn:
                                parent

                            text: "arrow_back"

                            color:
                                root.theme.textMuted

                            font.family:
                                "Material Symbols Rounded"

                            font.pixelSize: 17
                        }

                        MouseArea {
                            id: backHover

                            anchors.fill: parent

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            onClicked: {
                                root.appearanceSelected = false
                                root.previewPath = ""
                                root.searchText = ""

                                searchInput.text = ""
                            }
                        }
                    }

                    Text {
                        text:
                            root.appearanceMode === "dark"
                            ? "Dark"
                            : "Light"

                        color:
                            root.theme.textPrimary

                        font.family:
                            root.font

                        font.pixelSize: 13
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text:
                            root.filteredWallpapers.length +
                            " images"

                        color:
                            root.theme.textMuted

                        font.pixelSize: 11
                        font.family: root.font
                    }

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14

                        color:
                            refreshHover.containsMouse
                            ? root.theme.bgHover
                            : "transparent"

                        Text {
                            anchors.centerIn:
                                parent

                            text: "󰑐"

                            color:
                                root.theme.textMuted

                            font.pixelSize: 14
                            font.family: root.font
                        }

                        MouseArea {
                            id: refreshHover

                            anchors.fill: parent

                            hoverEnabled: true

                            cursorShape:
                                Qt.PointingHandCursor

                            onClicked:
                                WallpaperService.rescan()
                        }
                    }
                }

                // =================================================
                // SEARCH
                // =================================================

                Rectangle {
                    Layout.fillWidth: true

                    height: 36
                    radius: 8

                    color:
                        root.theme.bgSurface

                    border.color:
                        searchInput.activeFocus
                        ? root.theme.accentPrimary
                        : root.theme.bgBorder

                    border.width: 1

                    RowLayout {
                        anchors.fill: parent

                        anchors.leftMargin: 10
                        anchors.rightMargin: 10

                        spacing: 8

                        Text {
                            text: "search"

                            color:
                                root.theme.textMuted

                            font.family:
                                "Material Symbols Rounded"

                            font.pixelSize: 17

                            Layout.alignment:
                                Qt.AlignVCenter
                        }

                        TextInput {
                            id: searchInput

                            Layout.fillWidth: true
                            Layout.alignment:
                                Qt.AlignVCenter

                            color:
                                root.theme.textPrimary

                            font.pixelSize: 13
                            font.family: root.font

                            clip: true
                            selectByMouse: true

                            onTextChanged: {
                                root.searchText = text
                            }

                            Keys.onEscapePressed: {
                                if (
                                    root.previewPath !== ""
                                ) {
                                    root.previewPath = ""
                                } else if (
                                    root.appearanceSelected
                                ) {
                                    root.appearanceSelected = false
                                } else {
                                    wallpaperPanel.visible = false
                                }
                            }
                        }

                        Text {
                            text:
                                "Search wallpapers..."

                            color:
                                root.theme.textMuted

                            font.pixelSize: 13
                            font.family: root.font

                            visible:
                                searchInput.text === "" &&
                                !searchInput.activeFocus
                        }
                    }
                }

                // =================================================
                // GRID
                // =================================================

                GridView {
                    id: wallpaperGrid

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    cellWidth:
                        Math.floor(width / 4)

                    cellHeight:
                        cellWidth * 0.6 + 8

                    clip: true

                    boundsBehavior:
                        Flickable.StopAtBounds

                    model:
                        root.filteredWallpapers

                    delegate: Item {
                        required property string modelData
                        required property int index

                        width:
                            wallpaperGrid.cellWidth

                        height:
                            wallpaperGrid.cellHeight

                        Rectangle {
                            anchors.fill: parent

                            anchors.margins: 4

                            radius: 8

                            color:
                                root.theme.bgSurface

                            border.color:
                                WallpaperService.currentWallpaper === modelData
                                ? root.theme.accentPrimary
                                : (
                                    imgHover.containsMouse
                                    ? root.theme.bgBorder
                                    : "transparent"
                                )

                            border.width:
                                WallpaperService.currentWallpaper === modelData
                                ? 2
                                : 1

                            clip: true

                            Image {
                                anchors.fill: parent

                                anchors.margins: 2

                                source:
                                    "file://" + modelData

                                fillMode:
                                    Image.PreserveAspectCrop

                                sourceSize.width: 200
                                sourceSize.height: 120

                                asynchronous: true

                                Rectangle {
                                    anchors.fill: parent

                                    color:
                                        root.theme.bgSurface

                                    visible:
                                        parent.status !== Image.Ready

                                    Text {
                                        anchors.centerIn:
                                            parent

                                        text: "󰋩"

                                        color:
                                            root.theme.textMuted

                                        font.pixelSize: 24
                                        font.family:
                                            root.font
                                    }
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right

                                height: 22

                                color:
                                    root.theme.bgOverlay

                                Text {
                                    anchors.centerIn:
                                        parent

                                    text:
                                        modelData.split("/").pop()

                                    color:
                                        root.theme.textPrimary

                                    font.pixelSize: 9
                                    font.family: root.font

                                    elide:
                                        Text.ElideMiddle

                                    width:
                                        parent.width - 8

                                    horizontalAlignment:
                                        Text.AlignHCenter
                                }
                            }

                            Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right

                                anchors.margins: 6

                                width: 20
                                height: 20

                                radius: 10

                                color:
                                    root.theme.accentGreen

                                visible:
                                    WallpaperService.currentWallpaper
                                    === modelData

                                Text {
                                    anchors.centerIn:
                                        parent

                                    text: "check"

                                    color:
                                        root.theme.bgBase

                                    font.family:
                                        "Material Symbols Rounded"

                                    font.pixelSize: 12
                                }
                            }

                            MouseArea {
                                id: imgHover

                                anchors.fill: parent

                                hoverEnabled: true

                                cursorShape:
                                    Qt.PointingHandCursor

                                acceptedButtons:
                                    Qt.LeftButton |
                                    Qt.RightButton

                                onClicked: mouse => {
                                    if (
                                        mouse.button ===
                                        Qt.RightButton
                                    ) {
                                        root.previewPath =
                                            modelData
                                    } else {
                                        WallpaperService.setWallpaper(
                                            modelData,
                                            root.appearanceMode
                                        )

                                        // Close only AFTER
                                        // wallpaper was selected.
                                        root.appearanceSelected = false
                                        wallpaperPanel.visible = false
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn:
                            parent

                        text:
                            "󰋩  No wallpapers found\n" +
                            "Add images to ~/Pictures/Wallpapers/"

                        color:
                            root.theme.textMuted

                        font.pixelSize: 13
                        font.family: root.font

                        horizontalAlignment:
                            Text.AlignHCenter

                        visible:
                            wallpaperGrid.count === 0
                    }
                }
            }

            // ====================================================
            // PREVIEW
            // ====================================================

            Rectangle {
                anchors.fill: parent

                color:
                    Qt.rgba(0, 0, 0, 0.85)

                visible:
                    root.previewPath !== ""

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        root.previewPath = ""
                    }
                }

                Image {
                    anchors.centerIn:
                        parent

                    width:
                        parent.width * 0.8

                    height:
                        parent.height * 0.8

                    source:
                        root.previewPath !== ""
                        ? "file://" + root.previewPath
                        : ""

                    fillMode:
                        Image.PreserveAspectFit

                    asynchronous: true
                }

                Rectangle {
                    anchors.bottom:
                        parent.bottom

                    anchors.horizontalCenter:
                        parent.horizontalCenter

                    anchors.bottomMargin: 40

                    width:
                        applyRow.width + 32

                    height: 40

                    radius: 20

                    color:
                        root.theme.accentPrimary

                    Row {
                        id: applyRow

                        anchors.centerIn:
                            parent

                        spacing: 8

                        Text {
                            text: "wallpaper"

                            color:
                                root.theme.bgBase

                            font.family:
                                "Material Symbols Rounded"

                            font.pixelSize: 15

                            anchors.verticalCenter:
                                parent.verticalCenter
                        }

                        Text {
                            text: "Apply Wallpaper"

                            color:
                                root.theme.bgBase

                            font.pixelSize: 13
                            font.family: root.font
                            font.bold: true

                            anchors.verticalCenter:
                                parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        cursorShape:
                            Qt.PointingHandCursor

                        onClicked: {
                            WallpaperService.setWallpaper(
                                root.previewPath,
                                root.appearanceMode
                            )

                            root.previewPath = ""
                            root.appearanceSelected = false
                            wallpaperPanel.visible = false
                        }
                    }
                }
            }
        }
    }
}