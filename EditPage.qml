import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.10 as Kirigami

import org.kde.rattlesnake 1.0

Kirigami.ScrollablePage {
    title: qsTr("Edit beat")
    mainAction: Kirigami.Action {
        icon.name: "list-add"
        onTriggered: Metronome.addNote(0)
    }
    Kirigami.CardsListView {
        model: Metronome.notes
        delegate: Kirigami.Card {
            contentItem: Item {
                implicitWidth: delegateLayout.implicitWidth
                implicitHeight: delegateLayout.implicitHeight
                ColumnLayout {
                    id: delegateLayout
                    anchors.fill: parent
                    ButtonGroup {
                        buttons: column.children
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        id: column

                        InstrumentButton {
                            belongsToIndex: index
                            instrument: Metronome.Click
                        }

                        InstrumentButton {
                            belongsToIndex: index
                            instrument: Metronome.HighHead
                        }

                        InstrumentButton {
                            belongsToIndex: index
                            instrument: Metronome.Snare
                        }
                    }
                    Slider {
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
    }
}
