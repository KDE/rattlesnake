# SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
#
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

add_executable(rattlesnake main.cpp metronome.cpp note.cpp tapin.cpp qml.qrc media.qrc)

target_compile_definitions(rattlesnake PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(rattlesnake PRIVATE Qt6::Core Qt6::Quick Qt6::Multimedia Qt6::Widgets)
