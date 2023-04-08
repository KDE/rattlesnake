import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.rattlesnake 1.0

Button {
    property int belongsToIndex
    property int instrument
    checkable: true
    checked: Metronome.notes[belongsToIndex].sound === instrument
    icon.name: {
        switch (instrument) {
        case Metronome.D:
            return "go-down"
        case Metronome.E:
            return "gnumeric-object-line"
        case Metronome.F:
            return "go-up"
        }
    }

    onClicked: Metronome.notes[belongsToIndex].sound = instrument
}
