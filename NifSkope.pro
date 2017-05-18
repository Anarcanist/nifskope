###############################
## BUILD OPTIONS
###############################

TEMPLATE = app
TARGET   = NifSkope

QT += xml network widgets

# Require Qt 5.5 or higher
contains(QT_VERSION, ^5\\.[0-4]\\..*) {
        message("Cannot build NifSkope with Qt version $${QT_VERSION}")
        error("Minimum required version is Qt 5.5")
}

# C++11 Support
CONFIG += c++11

# Dependencies
CONFIG += half
# CONFIG += nvtristrip qhull soil zlib lz4 fsengine

# Debug/Release options
CONFIG(debug, debug|release) {
        # Debug Options
        BUILD = debug
        CONFIG += console
} else {
        # Release Options
        BUILD = release
        CONFIG -= console
        DEFINES += QT_NO_DEBUG_OUTPUT
}

INCLUDEPATH += src \
			src/datamodels \
			src/ui/ \
			src/ui/widgets \
			lib \


# Require explicit
DEFINES += \
        QT_NO_CAST_FROM_BYTEARRAY \ # QByteArray deprecations
        QT_NO_URL_CAST_FROM_STRING \ # QUrl deprecations
        QT_DISABLE_DEPRECATED_BEFORE=0x050300 #\ # Disable all functions deprecated as of 5.3

        # Useful for tracking down strings not using
        #	QObject::tr() for translations.
        # QT_NO_CAST_FROM_ASCII \
        # QT_NO_CAST_TO_ASCII


VISUALSTUDIO = false
*msvc* {
        ######################################
        ## Detect Visual Studio vs Qt Creator
        ######################################
        #	Qt Creator = shadow build
        #	Visual Studio = no shadow build

        # Strips PWD (source) from OUT_PWD (build) to test if they are on the same path
        #	- contains() does not work
        #	- equals( PWD, $${OUT_PWD} ) is not sufficient
        REP = $$replace(OUT_PWD, $${PWD}, "")

        # Test if Build dir is outside Source dir
        #	if REP == OUT_PWD, not Visual Studio
        !equals( REP, $${OUT_PWD} ):VISUALSTUDIO = true
        unset(REP)

        # Set OUT_PWD to ./bin so that qmake doesn't clutter PWD
        #	Unfortunately w/ VS qmake still creates empty debug/release folders in PWD.
        #	They are never used but get auto-generated because of CONFIG += debug_and_release
        $$VISUALSTUDIO:OUT_PWD = $${_PRO_FILE_PWD_}/bin
}

###############################
## FUNCTIONS
###############################

include(NifSkope_functions.pri)


###############################
## MACROS
###############################

# NifSkope Version
VER = $$getVersion()
# NifSkope Revision
REVISION = $$getRevision()

# NIFSKOPE_VERSION macro
DEFINES += NIFSKOPE_VERSION=\\\"$${VER}\\\"

# NIFSKOPE_REVISION macro
!isEmpty(REVISION) {
        DEFINES += NIFSKOPE_REVISION=\\\"$${REVISION}\\\"
}


###############################
## OUTPUT DIRECTORIES
###############################

# build_pass is necessary
# Otherwise it will create empty .moc, .ui, etc. dirs on the drive root
build_pass|!debug_and_release {
        win32:equals( VISUALSTUDIO, true ) {
                # Visual Studio
                DESTDIR = $${_PRO_FILE_PWD_}/bin/$${BUILD}
                # INTERMEDIATE FILES
                INTERMEDIATE = $${DESTDIR}/../GeneratedFiles/$${BUILD}
        } else {
                # Qt Creator
                DESTDIR = $${OUT_PWD}/$${BUILD}
                # INTERMEDIATE FILES
                INTERMEDIATE = $${DESTDIR}/../GeneratedFiles/
        }

        UI_DIR = $${INTERMEDIATE}/.ui
        MOC_DIR = $${INTERMEDIATE}/.moc
        RCC_DIR = $${INTERMEDIATE}/.qrc
        OBJECTS_DIR = $${INTERMEDIATE}/.obj
}

###############################
## TARGETS
###############################

include(NifSkope_targets.pri)


###############################
## PROJECT SCOPES
###############################

HEADERS += \
        src/actionmenu.h \
		src/datamodels/basemodel.h \
		src/datamodels/kfmmodel.h \
        src/message.h \
        src/nifexpr.h \
        src/nifitem.h \
		src/datamodels/nifmodel.h \
		src/datamodels/nifproxymodel.h \
        src/nifskope.h \
        src/niftypes.h \
        src/nifvalue.h \
        src/settings.h \
		src/ui/widgets/colorwheel.h \
		src/ui/widgets/fileselect.h \
		src/ui/widgets/floatedit.h \
		src/ui/widgets/floatslider.h \
		src/ui/widgets/groupbox.h \
		src/ui/widgets/nifcheckboxlist.h \
		src/ui/widgets/nifeditors.h \
		src/ui/widgets/nifview.h \
		src/ui/widgets/refrbrowser.h \
		src/ui/widgets/valueedit.h \
		src/ui/widgets/xmlcheck.h \
        src/ui/about_dialog.h \
        src/ui/checkablemessagebox.h \
        src/ui/settingsdialog.h \
        src/version.h

SOURCES += \
        src/actionmenu.cpp \
		src/datamodels/basemodel.cpp \
		src/datamodels/kfmmodel.cpp \
        src/kfmxml.cpp \
        src/message.cpp \
        src/nifdelegate.cpp \
        src/nifexpr.cpp \
		src/datamodels/nifmodel.cpp \
		src/datamodels/nifproxymodel.cpp \
        src/nifskope.cpp \
		src/ui/nifskope_ui.cpp \
        src/niftypes.cpp \
        src/nifvalue.cpp \
        src/nifxml.cpp \
        src/settings.cpp \
		src/ui/widgets/colorwheel.cpp \
		src/ui/widgets/fileselect.cpp \
		src/ui/widgets/floatedit.cpp \
		src/ui/widgets/floatslider.cpp \
		src/ui/widgets/groupbox.cpp \
		src/ui/widgets/nifcheckboxlist.cpp \
		src/ui/widgets/nifeditors.cpp \
		src/ui/widgets/nifview.cpp \
		src/ui/widgets/refrbrowser.cpp \
		src/ui/widgets/valueedit.cpp \
		src/ui/widgets/xmlcheck.cpp \
        src/ui/about_dialog.cpp \
        src/ui/checkablemessagebox.cpp \
        src/ui/settingsdialog.cpp \
        src/version.cpp

RESOURCES += \
        res/nifskope.qrc

FORMS += \
        src/ui/about_dialog.ui \
        src/ui/checkablemessagebox.ui \
        src/ui/nifskope.ui \
        src/ui/settingsdialog.ui \
        src/ui/settingsgeneral.ui \
        src/ui/settingsrender.ui \
        src/ui/settingsresources.ui


###############################
## DEPENDENCY SCOPES
###############################

fsengine {
        INCLUDEPATH += lib/fsengine
        HEADERS += \
                lib/fsengine/bsa.h \
                lib/fsengine/fsengine.h \
                lib/fsengine/fsmanager.h
        SOURCES += \
                lib/fsengine/bsa.cpp \
                lib/fsengine/fsengine.cpp \
                lib/fsengine/fsmanager.cpp
}

nvtristrip {
        INCLUDEPATH += lib/NvTriStrip
        HEADERS += \
                lib/NvTriStrip/NvTriStrip.h \
                lib/NvTriStrip/NvTriStripObjects.h \
                lib/NvTriStrip/VertexCache.h
        SOURCES += \
                lib/NvTriStrip/NvTriStrip.cpp \
                lib/NvTriStrip/NvTriStripObjects.cpp \
                lib/NvTriStrip/VertexCache.cpp
}

qhull {
        INCLUDEPATH += lib/qhull/src
        HEADERS += \
                lib/qhull/src/libqhull/geom.h \
                lib/qhull/src/libqhull/io.h \
                lib/qhull/src/libqhull/libqhull.h \
                lib/qhull/src/libqhull/mem.h \
                lib/qhull/src/libqhull/merge.h \
                lib/qhull/src/libqhull/poly.h \
                lib/qhull/src/libqhull/qhull_a.h \
                lib/qhull/src/libqhull/qset.h \
                lib/qhull/src/libqhull/random.h \
                lib/qhull/src/libqhull/stat.h \
                lib/qhull/src/libqhull/user.h
}

soil {
        INCLUDEPATH += lib/soil
        HEADERS += \
                lib/soil/image_DXT.h \
                lib/soil/image_helper.h \
                lib/soil/SOIL.h \
                lib/soil/stb_image_aug.h \
                lib/soil/stbi_DDS_aug.h \
                lib/soil/stbi_DDS_aug_c.h
        SOURCES += \
                lib/soil/image_DXT.c \
                lib/soil/image_helper.c \
                lib/soil/SOIL.c \
                lib/soil/stb_image_aug.c
}

zlib {
        INCLUDEPATH += lib/zlib

        HEADERS += \
                lib/zlib/crc32.h \
                lib/zlib/deflate.h \
                lib/zlib/gzguts.h \
                lib/zlib/inffast.h \
                lib/zlib/inffixed.h \
                lib/zlib/inflate.h \
                lib/zlib/inftrees.h \
                lib/zlib/trees.h \
                lib/zlib/zconf.h \
                lib/zlib/zlib.h \
                lib/zlib/zutil.h

        SOURCES += \
                lib/zlib/adler32.c \
                lib/zlib/compress.c \
                lib/zlib/crc32.c \
                lib/zlib/deflate.c \
                lib/zlib/gzclose.c \
                lib/zlib/gzlib.c \
                lib/zlib/gzread.c \
                lib/zlib/gzwrite.c \
                lib/zlib/infback.c \
                lib/zlib/inffast.c \
                lib/zlib/inflate.c \
                lib/zlib/inftrees.c \
                lib/zlib/trees.c \
                lib/zlib/uncompr.c \
                lib/zlib/zutil.c
}

lz4 {
        DEFINES += LZ4_STATIC XXH_PRIVATE_API

        HEADERS += \
                lib/lz4frame.h \
                lib/xxhash.h

        SOURCES += \
                lib/lz4frame.c \
                lib/xxhash.c
}

half {
        HEADERS += lib/half.h
        SOURCES += lib/half.cpp
}

###############################
## COMPILER SCOPES
###############################

QMAKE_CXXFLAGS_RELEASE -= -O
QMAKE_CXXFLAGS_RELEASE -= -O1
QMAKE_CXXFLAGS_RELEASE -= -O2

win32 {
        RC_FILE = res/icon.rc
        DEFINES += EDIT_ON_ACTIVATE
}

# MSVC
#  Both Visual Studio and Qt Creator
#  Required: msvc2013 or higher
*msvc* {

        # Grab _MSC_VER from the mkspecs that Qt was compiled with
        #	e.g. VS2013 = 1800, VS2012 = 1700, VS2010 = 1600
        _MSC_VER = $$find(QMAKE_COMPILER_DEFINES, "_MSC_VER")
        _MSC_VER = $$split(_MSC_VER, =)
        _MSC_VER = $$member(_MSC_VER, 1)

        # Reject unsupported MSVC versions
        !isEmpty(_MSC_VER):lessThan(_MSC_VER, 1900) {
                error("NifSkope only supports MSVC 2015 or later. If this is too prohibitive you may use Qt Creator with MinGW.")
        }

        # So VCProj Filters do not flatten headers/source
        CONFIG -= flat

        # COMPILER FLAGS

        #  Optimization flags
        QMAKE_CXXFLAGS_RELEASE *= -O2
        #  Multithreaded compiling for Visual Studio
        QMAKE_CXXFLAGS += -MP

        # LINKER FLAGS

        #  Relocate .lib and .exp files to keep release dir clean
        QMAKE_LFLAGS += /IMPLIB:$$syspath($${INTERMEDIATE}/NifSkope.lib)

        #  PDB location
        QMAKE_LFLAGS_DEBUG += /PDB:$$syspath($${INTERMEDIATE}/nifskope.pdb)
}


# MinGW, GCC
#  Recommended: GCC 4.8.1+
*-g++ {

        # COMPILER FLAGS

        #  Optimization flags
        QMAKE_CXXFLAGS_DEBUG -= -O0 -g
        QMAKE_CXXFLAGS_DEBUG *= -Og -g3
        QMAKE_CXXFLAGS_RELEASE *= -O3 -mfpmath=sse

        # C++11 Support
        QMAKE_CXXFLAGS_RELEASE *= -std=c++11

        #  Extension flags
        QMAKE_CXXFLAGS_RELEASE *= -msse2 -msse
}

win32 {
    # GL libs for Qt 5.5+
    #LIBS += -lopengl32 -lglu32
}

unix:!macx {
    #LIBS += -lGLU
}

macx {
    LIBS += -framework CoreFoundation
}


# Pre/Post Link in build_pass only
build_pass|!debug_and_release {

###############################
## QMAKE_PRE_LINK
###############################

        # Find `sed` command
        SED = $$getSed()

        !isEmpty(SED) {
                # Replace @VERSION@ with number from build/VERSION
                # Copy build/README.md.in > README.md
                QMAKE_PRE_LINK += $${SED} -e s/@VERSION@/$${VER}/ $${PWD}/build/README.md.in > $${PWD}/README.md $$nt
        }


###############################
## QMAKE_POST_LINK
###############################

        win32:DEP += \
                dep/NifMopp.dll

        XML += \
                build/docsys/nifxml/nif.xml \
                build/docsys/kfmxml/kfm.xml

        QSS += \
                res/style.qss

        #QHULLTXT += \
        #	lib/qhull/COPYING.txt

        #LANG += \
        #	res/lang

        #SHADERS += \
        #        res/shaders

        READMES += \
                CHANGELOG.md \
                CONTRIBUTORS.md \
                LICENSE.md \
                README.md \
                TROUBLESHOOTING.md


        #copyDirs( $$SHADERS, shaders )
        #copyDirs( $$LANG, lang )
		#copyFiles( $$QSS )
		copyFiles( $$XML )
        win32:copyFiles( $$DEP )

        # Copy Readmes and rename to TXT
        copyFiles( $$READMES,,,, md:txt )

        # Copy Qhull COPYING.TXT and rename
        #copyFiles( $$QHULLTXT,,, Qhull_COPYING.txt )

        win32:!static {
                # Copy DLLs to build dir
                copyFiles( $$QtBins(),, true )

                platforms += \
                        $$[QT_INSTALL_PLUGINS]/platforms/qminimal$${DLLEXT} \
                        $$[QT_INSTALL_PLUGINS]/platforms/qwindows$${DLLEXT}

                imageformats += \
                        $$[QT_INSTALL_PLUGINS]/imageformats/qjpeg$${DLLEXT} \
                        $$[QT_INSTALL_PLUGINS]/imageformats/qtga$${DLLEXT} \
                        $$[QT_INSTALL_PLUGINS]/imageformats/qwebp$${DLLEXT}

                copyFiles( $$platforms, platforms, true )
                copyFiles( $$imageformats, imageformats, true )
        }

} # end build_pass


# Build Messages
# (Add `buildMessages` to CONFIG to use)
buildMessages:build_pass|buildMessages:!debug_and_release {
        CONFIG(debug, debug|release) {
                message("Debug Mode")
        } CONFIG(release, release|debug) {
                message("Release Mode")
        }

        message(mkspec _______ $$QMAKESPEC)
        message(cxxflags _____ $$QMAKE_CXXFLAGS)
        message(arch _________ $$QMAKE_TARGET.arch)
        message(src __________ $$PWD)
        message(build ________ $$OUT_PWD)
        message(Qt binaries __ $$[QT_INSTALL_BINS])

        build_pass:equals( VISUALSTUDIO, true ) {
                message(Visual Studio __ Yes)
        }

        #message($$CONFIG)
}

# vim: set filetype=config :
