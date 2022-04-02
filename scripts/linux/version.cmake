if(WIN32)
    return()
endif()

# Will initialize needed CMAKE_ variables.
project(GenerateVersion CXX)

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
    set(LINUX TRUE)
endif()

if(NOT LINUX AND NOT APPLE)
    return()
endif()

find_package(Qt5 "5" REQUIRED COMPONENTS Core)
set(DLT_QT5_VERSION ${Qt5Core_VERSION} CACHE STRING "DLT_QT5_VERSION")
get_target_property(DLT_QT5_LIBRARY_PATH Qt5::Core LOCATION)
get_filename_component(DLT_QT5_LIB_DIR ${DLT_QT5_LIBRARY_PATH} DIRECTORY)

find_package(Git REQUIRED)
execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-list --count --no-merges HEAD
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_PATCH_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "${CMAKE_CURRENT_SOURCE_DIR}/scripts/linux/parse_version.sh" "${CMAKE_CURRENT_SOURCE_DIR}/src/version.h" PACKAGE_MAJOR_VERSION)
execute_process(
    COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/scripts/linux/parse_version.sh" "${CMAKE_CURRENT_SOURCE_DIR}/src/version.h" PACKAGE_MAJOR_VERSION
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/scripts/linux"
    OUTPUT_VARIABLE DLT_PROJECT_VERSION_MAJOR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE RESULT
)
if(RESULT AND NOT RESULT EQUAL 0)
    message(SEND_ERROR "Failure: ${RESULT}")
else()
    message(RESULT "Success.")
endif()

execute_process(
    COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/scripts/linux/parse_version.sh" "${CMAKE_CURRENT_SOURCE_DIR}/src/version.h" PACKAGE_MINOR_VERSION
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/scripts/linux"
    OUTPUT_VARIABLE DLT_PROJECT_VERSION_MINOR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
    COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/scripts/linux/parse_version.sh" "${CMAKE_CURRENT_SOURCE_DIR}/src/version.h" PACKAGE_PATCH_LEVEL
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/scripts/linux"
    OUTPUT_VARIABLE DLT_PROJECT_VERSION_PATCH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if("${CMAKE_CXX_LIBRARY_ARCHITECTURE}" STREQUAL "")
    set(CMAKE_CXX_LIBRARY_ARCHITECTURE "x86_64")
endif()

set(DLT_VERSION_SUFFIX "STABLE-qt${DLT_QT5_VERSION}-r${GIT_PATCH_VERSION}_${CMAKE_CXX_LIBRARY_ARCHITECTURE}_${CMAKE_CXX_COMPILER_VERSION}")