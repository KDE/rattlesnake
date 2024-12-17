# SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
#
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

cmake_minimum_required(VERSION 3.16)

project(rattlesnake LANGUAGES CXX)

set(QT_MIN_VERSION 6.4)
set(KF_MIN_VERSION 6.0)

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(FeatureSummary)
include(ECMSetupVersion)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(KDEGitCommitHooks)

find_package(Qt6 ${QT_MIN_VERSION} COMPONENTS Core Quick Multimedia Widgets REQUIRED)

find_package(KF6 ${KF_MIN_VERSION} REQUIRED COMPONENTS
    Kirigami
)

add_subdirectory(src)

install(TARGETS rattlesnake ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(PROGRAMS org.kde.rattlesnake.desktop DESTINATION ${KDE_INSTALL_APPDIR})
install(FILES org.kde.rattlesnake.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)

file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

kde_configure_git_pre_commit_hook(CHECKS CLANG_FORMAT)
