import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.rattlesnake 1.0
import org.kde.kirigami 2.10 as Kirigami

Button {
    property int belongsToIndex
    property int instrument
    checkable: true
    checked: Metronome.notes[belongsToIndex].sound === instrument
    contentItem: Item{
        Kirigami.Icon{
            id: buttonIcon
            isMask:true
            source: switch (instrument) {
                    case Metronome.D:
                        return "qrc:/media/icons/sound1.svg"
                    case Metronome.E:
                        return "qrc:/media/icons/sound2.svg"
                    case Metronome.F:
                        return "qrc:/media/icons/sound3.svg"
            }
            anchors.centerIn: parent
            height: Kirigami.Units.gridUnit*1.2
            width:height
        }
    }

    onClicked: Metronome.notes[belongsToIndex].sound = instrument
}
