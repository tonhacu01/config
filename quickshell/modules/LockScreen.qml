import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam

Item {
    id: root

    property bool active: sessionLock.locked

    // =========================================================
    // PUBLIC API
    // =========================================================

    function lock(): void {
        if (sessionLock.locked)
            return

        passwordInput.clear()
        sessionLock.locked = true
    }

    function unlock(): void {
        if (!sessionLock.locked)
            return

        sessionLock.locked = false
        passwordInput.clear()
    }

    function toggle(): void {
        if (sessionLock.locked)
            unlock()
        else
            lock()
    }

    // =========================================================
    // PAM AUTHENTICATION
    // =========================================================

    PamContext {
        id: pam

        // Uses /etc/pam.d/login
        config: "login"

        onPamMessage: {
            if (responseRequired) {
                respond(passwordInput.text)
            }
        }

        onCompleted: function(result) {
            if (result === PamResult.Success) {
                root.unlock()
            } else {
                passwordInput.clear()
                passwordInput.forceActiveFocus()
            }
        }

        onError: function(error) {
            passwordInput.clear()
            passwordInput.forceActiveFocus()
        }
    }

    // =========================================================
    // WAYLAND SESSION LOCK
    // =========================================================

    WlSessionLock {
        id: sessionLock

        locked: false

        surface: Component {
            WlSessionLockSurface {
                id: lockSurface

                color: "#000000"

                Rectangle {
                    anchors.fill: parent

                    color: "#000000"

                    // =================================================
                    // WALLPAPER
                    // =================================================

                    Image {
                        anchors.fill: parent

                        source: "file://" +
                                Quickshell.env("HOME") +
                                "/Pictures/Wallpapers/117497448_p0.jpg"

                        fillMode: Image.PreserveAspectCrop

                        asynchronous: true
                        cache: true

                        opacity: 0.82
                    }

                    // =================================================
                    // DARK OVERLAY
                    // =================================================

                    Rectangle {
                        anchors.fill: parent

                        color: "#35000000"
                    }

                    // =================================================
                    // TIME
                    // =================================================

                    Text {
                        id: timeText

                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 210

                        text: Qt.formatTime(
                            new Date(),
                            "HH:mm"
                        )

                        color: "#d8de91b3"

                        font.family: "SF Pro Display"
                        font.weight: Font.Bold
                        font.pixelSize: 85
                    }

                    // =================================================
                    // DATE
                    // =================================================

                    Text {
                        id: dateText

                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 165

                        text: Qt.formatDate(
                            new Date(),
                            "dddd, MMMM dd"
                        )

                        color: "#d8de91b3"

                        font.family: "SF Pro Display"
                        font.weight: Font.DemiBold
                        font.pixelSize: 30
                    }

                    // =================================================
                    // PROFILE + PASSWORD
                    // =================================================

                    ColumnLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter

                        anchors.verticalCenterOffset: -105

                        spacing: 14

                        // ---------------------------------------------
                        // PROFILE PICTURE
                        // ---------------------------------------------

                        Image {
                            Layout.alignment: Qt.AlignHCenter

                            width: 110
                            height: 110

                            source: "file://" +
                                    Quickshell.env("HOME") +
                                    "/.config/hypr/user-pfp.jpeg"

                            fillMode: Image.PreserveAspectCrop

                            smooth: true
                            asynchronous: true
                        }

                        // ---------------------------------------------
                        // USERNAME
                        // ---------------------------------------------

                        Text {
                            Layout.alignment: Qt.AlignHCenter

                            text: Quickshell.env("USER")

                            color: "#f5f5f5"

                            font.family: "SF Pro Text"
                            font.weight: Font.DemiBold
                            font.pixelSize: 20
                        }

                        // ---------------------------------------------
                        // PASSWORD FIELD
                        // ---------------------------------------------

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter

                            width: 270
                            height: 45

                            radius: 22

                            color: "#64727d66"

                            border.width: 2
                            border.color: "#00000000"

                            TextInput {
                                id: passwordInput

                                anchors.fill: parent

                                anchors.leftMargin: 18
                                anchors.rightMargin: 18

                                verticalAlignment:
                                    TextInput.AlignVCenter

                                color: "#eeeeee"

                                font.family: "SF Pro Display"
                                font.weight: Font.DemiBold
                                font.pixelSize: 16

                                echoMode: TextInput.Password

                                focus: true

                                selectByMouse: false

                                // -------------------------------------
                                // ENTER
                                // -------------------------------------

                                onAccepted: {
                                    if (text.length === 0)
                                        return

                                    if (!pam.active) {
                                        pam.start()
                                    }
                                }

                                // -------------------------------------
                                // ESC
                                // -------------------------------------

                                Keys.onEscapePressed: {
                                    clear()
                                }
                            }
                        }
                    }

                    // =================================================
                    // WEATHER / LOCATION
                    // =================================================

                    Text {
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        anchors.rightMargin: 95
                        anchors.bottomMargin: 40

                        text: "Hanoi, Vietnam"

                        color: "#ffffffcc"

                        font.family: "SF Pro Text"
                        font.pixelSize: 18
                    }

                    // =================================================
                    // CLOCK UPDATE
                    // =================================================

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true

                        onTriggered: {
                            timeText.text =
                                Qt.formatTime(
                                    new Date(),
                                    "HH:mm"
                                )

                            dateText.text =
                                Qt.formatDate(
                                    new Date(),
                                    "dddd, MMMM dd"
                                )
                        }
                    }

                    // =================================================
                    // FOCUS PASSWORD FIELD
                    // =================================================

                    Component.onCompleted: {
                        passwordInput.forceActiveFocus()
                    }
                }
            }
        }
    }
}