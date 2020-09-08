import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.rattlesnake 1.0

Button {
    property int belongsToIndex
    property int instrument
    checkable: true
    checked: Metronome.notes[belongsToIndex].sound === instrument
    text: {
        switch (instrument) {
        case Metronome.Click:
            return "Click"
        case Metronome.HighHead:
            return "Hi-Hat"
        case Metronome.Snare:
            return "Snare"
        }
    }

    onClicked: Metronome.notes[belongsToIndex].sound = instrument
}
