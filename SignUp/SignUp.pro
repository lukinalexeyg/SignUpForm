QT += qml \
    quick \
    widgets

CONFIG += c++17 \
    qtquickcompiler

CONFIG(release, debug|release) {
    CONFIG += optimize_full
}

TARGET = SignUp

TEMPLATE = app

VERSION = 1.0.0

win32-msvc* {
    QMAKE_CFLAGS += /MP
    QMAKE_CXXFLAGS += /MP
}

QMAKE_TARGET = $${TARGET}
QMAKE_TARGET_PRODUCT = $${TARGET}
QMAKE_TARGET_DESCRIPTION = "SignUp"
QMAKE_TARGET_COPYRIGHT = "Copyright (c) 2021 Alexey Lukin"

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += APP_PRODUCT=\\\"$$QMAKE_TARGET_PRODUCT\\\"
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

SOURCES += main.cpp \
    clipboardadapter.cpp \
    core.cpp

HEADERS += \
    clipboardadapter.h \
    core.h \
    log.h

RESOURCES += \
    resources.qrc

DESTDIR = bin
MOC_DIR = moc
OBJECTS_DIR = obj
RCC_DIR = rcc
UI_DIR = ui

copydata.commands = $(COPY_FILE) $$shell_path($$PWD\..\countries.json) $$shell_path($$DESTDIR)
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata
