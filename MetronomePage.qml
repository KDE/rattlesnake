// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.10 as Kirigami
import org.kde.kirigamiaddons.labs.mobileform 0.1 as MobileForm

import org.kde.rattlesnake 1.0

import "components"

Kirigami.Page {
    leftPadding: 0
    rightPadding: 0
    Component.onCompleted: {
        Metronome.addNote(0)
        Metronome.addNote(0)
        Metronome.addNote(0)
    }


    title: qsTr("Metronome")
    id: page
    footer: ProgressBar {
        height: TapIn.tapCounter === 0 ? 0 : 15
        Behavior on height {
            NumberAnimation {}
        }

        from: 0
        to: 4
        value: TapIn.tapCounter

        Behavior on value {
            NumberAnimation {}
        }
    }


    Connections {
        target: TapIn
        function onTapStopped() {
            Metronome.bpm = TapIn.bpm
            container.state = "resized"
            Metronome.start()
        }
    }
    DoubleActionButton {
        parent: overlay
        x: root.width - width - margin
        y: root.height - height - pageStack.globalToolBar.preferredHeight - margin
        rightAction: Kirigami.Action {
            icon.name: "qrc:/media/icons/tap-in.svg"
            text: qsTr("Tap-In")
            onTriggered: {
                Metronome.stop()
                TapIn.tap()
            }
        }
        leftAction: Kirigami.Action {
            icon.name: "document-edit"
            text: qsTr("Edit Beat")
            onTriggered: pageStack.push("qrc:/EditPage.qml")
        }
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.alignment: Qt.AlignCenter
//            Layout.maximumWidth: 5
            Layout.preferredWidth: 10
//            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Button {
                icon.name: "list-remove"
                onClicked: Metronome.removeNote(repeater.count - 1)
                enabled: Metronome.notes.length > 1
            }
            ScrollView {
                Layout.maximumWidth: 300
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                RowLayout {
                    height: editor.height
                    Item {
                        implicitHeight: 4
                        //spacer
                    }
                    Repeater {
                        id: repeater
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: Metronome.notes
                        delegate: Button {
                            implicitWidth: height
                            flat:/* index !== Metronome.currentIndex*/ true
                            implicitHeight: Kirigami.Units.gridUnit*3

                            Layout.alignment: Qt.AlignVCenter
                            contentItem: Item{
                                Kirigami.Icon{
                                    id: buttonIcon
                                    isMask:true
                                    opacity: 0.7
                                    color: index !== Metronome.currentIndex ? Kirigami.Theme.textColor:Kirigami.Theme.hoverColor
                                    source: if (modelData.sound === 0) {
                                            "qrc:/media/icons/sound1.svg"
                                        } else if (modelData.sound === 1) {
                                            "qrc:/media/icons/sound2.svg"
                                        } else if (modelData.sound === 2) {
                                            "qrc:/media/icons/sound3.svg"
                                        }
                                    anchors.centerIn: parent
                                    height: Kirigami.Units.gridUnit*3
                                    width:height
                                }
                            }


                            onClicked: {
                                let instrumentIndex = Metronome.notes[model.index].sound
                                let newIndex = ((instrumentIndex + 1) % 3)
                                console.log(newIndex)
                                Metronome.notes[model.index].sound = newIndex
                            }
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                        // spacer
                    }
                }
            }

            Button {
                icon.name: "list-add"
                onClicked: Metronome.addNote(0)
            }
            Item { Layout.fillWidth: true }

        }

        Item {
            Layout.fillHeight: true
        }

        MobileForm.FormCard {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing:0
                MobileForm.AbstractFormDelegate {
                    background: Rectangle {
                        color: index === Metronome.currentIndex ?Kirigami.Theme.highlightColor:"transparent"
                        opacity: 0.2

                    }
                    contentItem: ColumnLayout {

                        Label {
                            color: Kirigami.Theme.disabledTextColor
                            Layout.alignment: Qt.AlignHCenter
                            text: "BPM:"
                        }
                        Kirigami.Heading {
                            Layout.alignment: Qt.AlignHCenter
                            text: Metronome.bpm
                        }
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter

                            ToolButton {
                                icon.name: "go-previous"
                                onClicked: Metronome.bpm = Metronome.bpm -1

                            }
                            Dial {
                                id: dial
                                value: Metronome.bpm
                                from: 20
                                to: 400

                                Behavior on value {
                                    NumberAnimation {}
                                }

                                onMoved: {
                                    Metronome.bpm = value
                                }
                                contentItem: Item {
                                    id: container
                                    anchors.fill: dial
                                    Rectangle {
                                        id: animation
                                        anchors.centerIn: parent
                                        width: height
                                        height: playPauseButton.height * 0.75
                                        radius: height * 0.5
                                        color: Kirigami.Theme.hoverColor
                                    }
                                    states: [
                                        State {
                                            name: "resized"
                                            PropertyChanges {
                                                target: animation
                                                height: 600
                                                opacity: 0
                                            }
                                        },
                                        State {
                                            name: "normal"
                                            PropertyChanges {
                                                target: animation
                                                height: playPauseButton.height * 0.75
                                                opacity: 0.5
                                            }
                                        }
                                    ]
                                    state: "normal"
                                    transitions: Transition {
                                        enabled: container.state == "normal"

                                        onRunningChanged: if (!running) {
                                                              container.state = "normal"
                                                          }
                                        PropertyAnimation {

                                            properties: "height, opacity"
                                            easing.type: Easing.InOutQuad
                                        }
                                    }
                                    RoundButton {
                                        z: 1000
                                        height: width
                                        width: 50
                                        id: playPauseButton
                                        anchors.centerIn: parent
                                        checkable: true
                                        checked: Metronome.running
                                        icon.name: checked ? "media-playback-pause" : "media-playback-start"
                                        onClicked: checked ? Metronome.start() : Metronome.stop()
                                    }
                                }
                            }
                            ToolButton {
                                icon.name: "go-next"
                                onClicked: Metronome.bpm = Metronome.bpm + 1

                            }
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
