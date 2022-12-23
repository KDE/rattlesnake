import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.10 as Kirigami

import org.kde.rattlesnake 1.0

Kirigami.Page {
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

    mainAction: Kirigami.Action {
        icon.name: "zoom-original"
        text: qsTr("Tap")
        onTriggered: {
            Metronome.stop()
            TapIn.tap()
        }
    }
    leftAction: Kirigami.Action {
        icon.name: "document-edit"
        text: "Edit Beat"
        onTriggered: pageStack.push("qrc:/EditPage.qml")
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Button {
                icon.name: "list-remove"
                onClicked: Metronome.removeNote(repeater.count - 1)
                enabled: Metronome.notes.length > 1
            }
            Kirigami.Card {
                id: editor
                Layout.fillWidth: true
                implicitHeight: 50
                ScrollView {
                    anchors.fill: parent
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                    RowLayout {
                        height: editor.height
                        Item {
                            implicitWidth: 4
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
                                flat: index !== Metronome.currentIndex

                                Layout.alignment: Qt.AlignVCenter
                                text: modelData.sound + 1
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
            }
            Button {
                icon.name: "list-add"
                onClicked: Metronome.addNote(0)
            }
        }

        Item {
            Layout.fillHeight: true
        }
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "BPM:"
        }
        SpinBox {
            Layout.alignment: Qt.AlignHCenter
            from: dial.from
            to: dial.to
            editable: true
            value: Metronome.bpm
            onValueModified: Metronome.bpm = value
        }
        Dial {
            id: dial
            Layout.alignment: Qt.AlignHCenter
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
                    color: "white"
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
                            opacity: 100
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
        Item {
            Layout.fillHeight: true
        }
    }
}
