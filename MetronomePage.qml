import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.10 as Kirigami

import org.kde.rattlesnake 1.0

Kirigami.Page {
    title: qsTr("Metronome")
    ColumnLayout {
        anchors.fill: parent

        Button {
            id: tapButton
            onClicked: TapIn.tap()

            Connections {
                target: TapIn
                onTapStopped: {
                    Metronome.bpm = TapIn.bpm
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Button {
                icon.name: "list-remove"
                onClicked: Metronome.removeNote(repeater.count - 1)
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
                                onClicked: pageStack.push("qrc:/EditPage.qml")
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
            onMoved: {
                Metronome.bpm = value
            }
            contentItem: Item {
                anchors.fill: dial

                RoundButton {
                    flat: true
                    anchors.centerIn: parent
                    checkable: true
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
