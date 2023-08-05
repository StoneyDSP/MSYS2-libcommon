cmake_minimum_required(VERSION 3.17...3.27 FATAL_ERROR)

project(LibCommon)
enable_language(C)

include(GNUInstallDirs)
set(LibCommon_INCLUDEDIR "${CMAKE_CURRENT_BINARY_DIR}/include")

include(CheckFunctionExists)
set(LIBCOMMON_REQUIRED_SYSTEM_FUNCTIONS)
list(APPEND LIBCOMMON_REQUIRED_SYSTEM_FUNCTIONS "strndup")
list(APPEND LIBCOMMON_REQUIRED_SYSTEM_FUNCTIONS "strnlen")
list(APPEND LIBCOMMON_REQUIRED_SYSTEM_FUNCTIONS "strsep")
foreach (_symbol IN LISTS LIBCOMMON_REQUIRED_SYSTEM_FUNCTIONS)
	# set(CMAKE_REQUIRED_DEFINITIONS "_GNU_SOURCE")
	check_function_exists("${_symbol}" has_${_symbol})
	if(has_${_symbol})
		##-- These shall print integer 0's or 1's
		string(TOUPPER ${_symbol} _symbol)
		set(HAVE_${_symbol} 1 CACHE BOOL "" FORCE)
	endif()
	unset(has_${_symbol})
endforeach()
unset(_symbol)

if (NOT ${PROJECT_SOURCE_DIR} EQUAL ${PROJECT_BINARY_DIR})

	# configure_file ("include/common/defines.h"       							"include/common/defines.h")

    configure_file ("include/pacman/common/ini.h"       						"include/pacman/common/ini.h")
	configure_file ("include/pacman/common/util-common.h"        				"include/pacman/common/util-common.h")

	configure_file ("src/pacman/common/ini.c"          							"src/pacman/common/ini.c")
    configure_file ("src/pacman/common/util-common.c"             				"src/pacman/common/util-common.c")

endif ()

add_library (common 															STATIC)
add_library (pacman::common                    									ALIAS common)

target_include_directories (common

    PUBLIC

        $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# include("./include/common/CMakeLists.txt")

target_sources (common

    PUBLIC

        FILE_SET common_PUBLIC_HEADERS
        TYPE HEADERS
        BASE_DIRS
            $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include/pacman/common>
            $<INSTALL_INTERFACE:include/pacman/common>
        FILES
            # include/pacman/common/ini.h
            $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include/pacman/common/ini.h>
            $<INSTALL_INTERFACE:include/pacman/common/ini.h>
			# include/pacman/common/util-common.h
            $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include/pacman/common/util-common.h>
            $<INSTALL_INTERFACE:include/pacman/common/util-common.h>
)

# include("./src/common/CMakeLists.txt")

target_sources (common

    PRIVATE

		# src/pacman/common/ini.c
		$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src/pacman/common/ini.c>
		$<INSTALL_INTERFACE:src/pacman/common/ini.c>
		# src/pacman/common/util-common.c
		$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/src/pacman/common/util-common.c>
		$<INSTALL_INTERFACE:src/pacman/common/util-common.c>
)

set_target_properties (common

    PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY bin
        LIBRARY_OUTPUT_DIRECTORY lib
        ARCHIVE_OUTPUT_DIRECTORY lib
        PDB_OUTPUT_DIRECTORY     bin

		C_STANDARD 99
		C_STANDARD_REQUIRED TRUE
		VISIBILITY_INLINES_HIDDEN TRUE
		HAS_CXX FALSE
)

target_compile_features(common PUBLIC c_std_99)

# find_package(pacman)
# target_link_libraries(common PUBLIC pacman::configuration)



install(
	TARGETS common
	EXPORT LibCommonTargets
	LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
	INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    FILE_SET common_PUBLIC_HEADERS
)

install (
	EXPORT LibCommonTargets
	FILE LibCommonTargets.cmake
	NAMESPACE pacman::
	DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/pacman/common"
)


# ##-- Create package config
include (CMakePackageConfigHelpers)

configure_package_config_file (
	"${CMAKE_CURRENT_SOURCE_DIR}/share/LibCommonConfig.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/share/LibCommonConfig.cmake"
	INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/LibCommon"
)

install (
	FILES
		"${CMAKE_CURRENT_BINARY_DIR}/share/LibCommonConfig.cmake"
		# "${CMAKE_CURRENT_BINARY_DIR}/share/LibCommonConfigVersion.cmake"
	DESTINATION
		"${CMAKE_INSTALL_LIBDIR}/cmake/LibCommon"
)

export(
	EXPORT LibCommonTargets
	FILE "${CMAKE_CURRENT_BINARY_DIR}/share/LibCommonTargets.cmake"
	NAMESPACE pacman::
)
