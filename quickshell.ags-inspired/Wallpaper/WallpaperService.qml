pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // ============================================================
    // PROPERTIES
    // ============================================================

    property list<string> wallpapers: []
    property string currentWallpaper: ""
    property string backend: "awww"
    property bool isChanging: false
    property bool isGeneratingColors: false

    // ============================================================
    // PATHS
    // ============================================================

    readonly property string home:
        Quickshell.env("HOME")

    readonly property string wallpaperDir:
        home + "/Pictures/Wallpapers"

    readonly property string wallpaperConfig:
        home + "/.config/quickshell/wallpaper.conf"

    readonly property string matugenConfig:
        home + "/.config/matugen/config.toml"

    // ============================================================
    // SCAN WALLPAPERS
    // ============================================================

    Process {
        id: scanner

        command: [
            "sh",
            "-c",
            "find " +
            "\"" + root.wallpaperDir + "\" " +
            "-maxdepth 2 " +
            "-type f \\( " +
            "-iname '*.jpg' -o " +
            "-iname '*.jpeg' -o " +
            "-iname '*.png' -o " +
            "-iname '*.webp' " +
            "\\) " +
            "2>/dev/null | " +
            "sort -u | " +
            "head -200"
        ]

        running: false

        stdout: SplitParser {
            onRead: data => {
                const path = data.trim()

                if (
                    path !== "" &&
                    !root.wallpapers.includes(path)
                ) {
                    root.wallpapers = [
                        ...root.wallpapers,
                        path
                    ]
                }
            }
        }

        onExited: {
            console.log(
                "[Wallpaper] Scan finished:",
                root.wallpapers.length,
                "wallpapers"
            )
        }
    }

    // ============================================================
    // LOAD SAVED WALLPAPER
    // ============================================================

    FileView {
        id: configFile

        path: root.wallpaperConfig

        onTextChanged: {
            const saved =
                configFile.text().trim()

            if (
                saved !== "" &&
                root.currentWallpaper !== saved
            ) {
                root.currentWallpaper = saved
            }
        }
    }

    // ============================================================
    // AWWW
    // ============================================================

    Process {
        id: setProcess

        command: []
        running: false

        onStarted: {
            root.isChanging = true

            console.log(
                "[Wallpaper] Setting:",
                root.currentWallpaper
            )
        }

        onExited: exitCode => {
            root.isChanging = false

            console.log(
                "[Wallpaper] awww exited:",
                exitCode
            )
        }
    }

    // ============================================================
    // SAVE WALLPAPER PATH
    // ============================================================

    Process {
        id: saveProcess

        command: []
        running: false

        onExited: exitCode => {
            if (exitCode !== 0) {
                console.warn(
                    "[Wallpaper] Failed to save wallpaper path"
                )
            }
        }
    }

    // ============================================================
    // MATUGEN
    // ============================================================

    Process {
        id: matugenProcess

        command: []
        running: false

        stdout: SplitParser {
            onRead: data => {
                const line = data.trim()

                if (line !== "") {
                    console.log(
                        "[Matugen]",
                        line
                    )
                }
            }
        }

        stderr: SplitParser {
            onRead: data => {
                const line = data.trim()

                if (line !== "") {
                    console.warn(
                        "[Matugen]",
                        line
                    )
                }
            }
        }

        onStarted: {
            root.isGeneratingColors = true

            console.log(
                "[Wallpaper] Generating Matugen colors..."
            )
        }

        onExited: exitCode => {
            root.isGeneratingColors = false

            if (exitCode === 0) {
                console.log(
                    "[Wallpaper] Matugen finished successfully"
                )

                reloadColorsProcess.running = true
            } else {
                console.warn(
                    "[Wallpaper] Matugen failed:",
                    exitCode
                )
            }
        }
    }

    // ============================================================
    // RELOAD QUICKSHELL COLORS
    // ============================================================

    Process {
        id: reloadColorsProcess

        command: [
            "sh",
            "-c",
            "true"
        ]

        running: false
    }

    // ============================================================
    // INITIAL SCAN
    // ============================================================

    Component.onCompleted: {
        scanner.running = true
    }

    // ============================================================
    // RESCAN
    // ============================================================

    function rescan() {
        root.wallpapers = []

        scanner.running = false
        scanner.running = true
    }

    // ============================================================
    // SET WALLPAPER
    // ============================================================

    function setWallpaper(path) {
        if (!path || path === "")
            return

        // --------------------------------------------------------
        // Prevent duplicate request
        // --------------------------------------------------------

        if (
            setProcess.running ||
            matugenProcess.running
        ) {
            return
        }

        // --------------------------------------------------------
        // Store current wallpaper
        // --------------------------------------------------------

        root.currentWallpaper = path

        // --------------------------------------------------------
        // AWWW
        // --------------------------------------------------------

        setProcess.command = [
            root.backend,
            "img",
            path,
            "--transition-type",
            "grow",
            "--transition-pos",
            "center",
            "--transition-duration",
            "1"
        ]

        setProcess.running = true

        // --------------------------------------------------------
        // SAVE PATH
        // --------------------------------------------------------

        saveProcess.command = [
            "sh",
            "-c",
            "mkdir -p \"$HOME/.config/quickshell\" && " +
            "printf '%s' \"$1\" > " +
            "\"$HOME/.config/quickshell/wallpaper.conf\"",
            "sh",
            path
        ]

        saveProcess.running = true

        // --------------------------------------------------------
        // MATUGEN
        // --------------------------------------------------------

        matugenProcess.command = [
            "matugen",
            "image",
            path,
            "-m",
            "dark"
        ]

        matugenProcess.running = true
    }

    // ============================================================
    // REGENERATE CURRENT WALLPAPER
    // ============================================================

    function regenerateColors() {
        if (
            !root.currentWallpaper ||
            root.currentWallpaper === ""
        ) {
            console.warn(
                "[Wallpaper] No current wallpaper"
            )

            return
        }

        if (matugenProcess.running)
            return

        matugenProcess.command = [
            "matugen",
            "image",
            root.currentWallpaper,
            "-m",
            "dark"
        ]

        matugenProcess.running = true
    }
}