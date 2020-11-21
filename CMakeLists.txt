cmake_minimum_required(VERSION 3.1)

project(rattlesnake LANGUAGES CXX)

set(KF5_MIN_VERSION "5.60.0")

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(FeatureSummary)
include(ECMSetupVersion)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(ECMQMLModules)
include(ECMConfiguredInstall)

find_package(Qt5 COMPONENTS Core Quick Multimedia Widgets REQUIRED)

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
	Kirigami2
)

add_executable(${PROJECT_NAME} "main.cpp" "metronome.cpp" "note.cpp" "tapin.cpp" "qml.qrc" "media.qrc")
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick Qt5::Multimedia Qt5::Widgets)

install(TARGETS ${PROJECT_NAME} ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
install(PROGRAMS org.kde.rattlesnake.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.rattlesnake.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)
