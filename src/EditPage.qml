// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.10 as Kirigami
import org.kde.kirigamiaddons.formcard as FormCard
import org.kde.kirigamiaddons.components as Components

import org.kde.rattlesnake 1.0

Kirigami.ScrollablePage {
    id:root
    title: qsTr("Edit beat")
    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    padding: 0

    Components.FloatingButton{
        parent: overlay
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: Kirigami.Units.largeSpacing
        }
        action:  Kirigami.Action {
            icon.name: "list-add"
            text: qsTr("Add Beat")
            onTriggered: Metronome.addNote(0)
        }

    }
    ColumnLayout {
        FormCard.FormCard {
            Layout.topMargin: Kirigami.Units.largeSpacing
            Repeater {
                id: repeater
                model: Metronome.notes
                delegate: ColumnLayout {
                    required property int index
                    spacing:0
                    Layout.margins: 0
                    FormCard.AbstractFormDelegate {
                        background: Rectangle {
                            color: index === Metronome.currentIndex ?Kirigami.Theme.highlightColor:"transparent"
                            opacity: 0.2

                        }
                        contentItem: ColumnLayout {
                            id: delegateLayout
                            ButtonGroup {
                                buttons: column.children
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Item {
                                    width: deleteButton.width
                                    visible: index > 0
                                }

                                Item { Layout.fillWidth: true }
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    id: column

                                    InstrumentButton {
                                        belongsToIndex: index
                                        instrument: Metronome.D
                                    }

                                    InstrumentButton {
                                        belongsToIndex: index
                                        instrument: Metronome.E
                                    }

                                    InstrumentButton {
                                        belongsToIndex: index
                                        instrument: Metronome.F
                                    }
                                }
                                Item { Layout.fillWidth: true }

                                ToolButton {
                                    id: deleteButton
                                    visible: index > 0
                                    icon.name: "delete"
                                    onClicked: Metronome.removeNote(index)
                                }
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                ToolButton {
                                    icon.name: Metronome.notes[index].volume === 0 ? "audio-volume-muted" : (Metronome.notes[index].volume < 33 ? "audio-volume-low" : (Metronome.notes[index].volume < 66 ? "audio-volume-medium" : "audio-volume-high"))
                                    checkable: true
                                    checked: Metronome.notes[index].volume === 0
                                    onClicked: Metronome.notes[index].volume = 0

                                }
                                Slider {
                                    id:slider
                                    Layout.alignment: Qt.AlignHCenter
                                    from: 0
                                    to: 100
                                    snapMode: Slider.SnapAlways
                                    stepSize: 10
                                    value: Metronome.notes[index].volume
                                    onMoved: Metronome.notes[index].volume = value
                                }
                            }
                        }
                    }
                    FormCard.FormDelegateSeparator {
                        visible: index != repeater.count -1
                    }
                }
            }
        }
    }
}
