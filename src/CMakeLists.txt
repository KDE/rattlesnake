add_executable(rattlesnake main.cpp metronome.cpp note.cpp tapin.cpp qml.qrc media.qrc)

target_compile_definitions(rattlesnake PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(rattlesnake PRIVATE Qt6::Core Qt6::Quick Qt6::Multimedia Qt6::Widgets)
