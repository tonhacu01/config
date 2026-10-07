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

    // Main Matugen configuration.
    //
    // This config generates the complete desktop theme:
    // Kitty, Hyprland, Waybar, GTK, Rofi, Quickshell,
    // Walker, Code-OSS, SwayNC, etc.
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

        onExited: exitCode => {
            console.log(
                "[Wallpaper] Scan finished:",
                root.wallpapers.length,
                "wallpapers"
            )

            if (exitCode !== 0) {
                console.warn(
                    "[Wallpaper] Scanner exited:",
                    exitCode
                )
            }
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

            if (exitCode === 0) {
                console.log(
                    "[Wallpaper] awww finished successfully"
                )
            } else {
                console.warn(
                    "[Wallpaper] awww exited:",
                    exitCode
                )
            }
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
                    "[Wallpaper] Failed to save wallpaper path:",
                    exitCode
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
                    console.error(
                        "[Matugen]",
                        line
                    )
                }
            }
        }

        onStarted: {
            root.isGeneratingColors = true

            console.log(
                "[Matugen] Starting..."
            )

            console.log(
                "[Matugen] Wallpaper:",
                root.currentWallpaper
            )

            console.log(
                "[Matugen] Config:",
                root.matugenConfig
            )
        }

        onExited: exitCode => {
            root.isGeneratingColors = false

            console.log(
                "[Matugen] Exit code:",
                exitCode
            )

            if (exitCode === 0) {
                console.log(
                    "[Matugen] Full desktop theme generated successfully"
                )
            } else {
                console.error(
                    "[Matugen] Failed with exit code:",
                    exitCode
                )
            }
        }
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
        if (!path || path === "") {
            console.warn(
                "[Wallpaper] Invalid wallpaper path"
            )
            return
        }

        // --------------------------------------------------------
        // Prevent duplicate request
        // --------------------------------------------------------

        if (
            setProcess.running ||
            matugenProcess.running
        ) {
            console.log(
                "[Wallpaper] A wallpaper/theme change is already running"
            )
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
        // SAVE WALLPAPER PATH
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
        //
        // IMPORTANT:
        // Keep this invocation identical to set.sh.
        //
        // scheme-tonal-spot:
        //   same scheme used by set.sh
        //
        // source-color-index 0:
        //   deterministic source-color selection
        //
        // Without these two options, this QML path was using
        // Matugen's other/default selection behavior, which could
        // produce a completely different palette.
        // --------------------------------------------------------

        matugenProcess.command = [
            "matugen",
            "image",
            path,
            "-c",
            root.matugenConfig,
            "-m",
            "dark",
            "--type",
            "scheme-tonal-spot",
            "--source-color-index",
            "0"
        ]

        console.log(
            "[Wallpaper] Running:",
            matugenProcess.command.join(" ")
        )

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

        if (matugenProcess.running) {
            console.log(
                "[Matugen] Matugen is already running"
            )
            return
        }

        matugenProcess.command = [
            "matugen",
            "image",
            root.currentWallpaper,
            "-c",
            root.matugenConfig,
            "-m",
            "dark",
            "--type",
            "scheme-tonal-spot",
            "--source-color-index",
            "0"
        ]

        console.log(
            "[Wallpaper] Regenerating:",
            matugenProcess.command.join(" ")
        )

        matugenProcess.running = true
    }
}
