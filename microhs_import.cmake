if (DEFINED ENV{MICROHS_PATH} AND (NOT MICROHS_PATH))
    set(MICROHS_PATH $ENV{MICROHS_PATH})
    message("Using MICROHS_PATH from environment ('${MICROHS_PATH}')")
endif ()

if (DEFINED ENV{MICROHS_FETCH_FROM_GIT} AND (NOT MICROHS_FETCH_FROM_GIT))
    set(MICROHS_FETCH_FROM_GIT $ENV{MICROHS_FETCH_FROM_GIT})
    message("Using MICROHS_FETCH_FROM_GIT from environment ('${MICROHS_FETCH_FROM_GIT}')")
endif ()

if (DEFINED ENV{MICROHS_FETCH_FROM_GIT_PATH} AND (NOT MICROHS_FETCH_FROM_GIT_PATH))
    set(MICROHS_FETCH_FROM_GIT_PATH $ENV{MICROHS_FETCH_FROM_GIT_PATH})
    message("Using MICROHS_FETCH_FROM_GIT_PATH from environment ('${MICROHS_FETCH_FROM_GIT_PATH}')")
endif ()

if (DEFINED ENV{MICROHS_FETCH_FROM_GIT_TAG} AND (NOT MICROHS_FETCH_FROM_GIT_TAG))
    set(MICROHS_FETCH_FROM_GIT_TAG $ENV{MICROHS_FETCH_FROM_GIT_TAG})
    message("Using MICROHS_FETCH_FROM_GIT_TAG from environment ('${MICROHS_FETCH_FROM_GIT_TAG}')")
endif ()

if (MICROHS_FETCH_FROM_GIT AND NOT MICROHS_FETCH_FROM_GIT_TAG)
  set(MICROHS_FETCH_FROM_GIT_TAG "raspberry-pico-experiment")
  # set(MICROHS_FETCH_FROM_GIT_TAG "master")
  message("Using master as default value for MICROHS_FETCH_FROM_GIT_TAG")
endif()

set(MICROHS_PATH "${MICROHS_PATH}" CACHE PATH "Path to MicroHs")
set(MICROHS_FETCH_FROM_GIT "${MICROHS_FETCH_FROM_GIT}" CACHE BOOL "Set to ON to fetch copy of MicroHs from git if not otherwise locatable")
set(MICROHS_FETCH_FROM_GIT_PATH "${MICROHS_FETCH_FROM_GIT_PATH}" CACHE FILEPATH "location to download MicroHs")
set(MICROHS_FETCH_FROM_GIT_TAG "${MICROHS_FETCH_FROM_GIT_TAG}" CACHE FILEPATH "release tag for MicroHs")

if (NOT MICROHS_PATH)
    if (MICROHS_FETCH_FROM_GIT)
        include(FetchContent)
        set(FETCHCONTENT_BASE_DIR_SAVE ${FETCHCONTENT_BASE_DIR})
        if (MICROHS_FETCH_FROM_GIT_PATH)
            get_filename_component(FETCHCONTENT_BASE_DIR "${MICROHS_FETCH_FROM_GIT_PATH}" REALPATH BASE_DIR "${CMAKE_SOURCE_DIR}")
        endif ()
        # GIT_SUBMODULES_RECURSE was added in 3.17
        if (${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.17.0")
            FetchContent_Declare(
                    microhs
                    GIT_REPOSITORY https://github.com/liolin/MicroHs
                    GIT_TAG ${MICROHS_FETCH_FROM_GIT_TAG}
                    GIT_SUBMODULES_RECURSE FALSE
            )
        else ()
            FetchContent_Declare(
                    microhs
                    GIT_REPOSITORY https://github.com/liolin/MicroHs
                    GIT_TAG ${MICROHS_FETCH_FROM_GIT_TAG}
            )
        endif ()

        if (NOT microhs)
            message("Downloading MicroHs")
            FetchContent_Populate(microhs)
            set(MICROHS_PATH ${microhs_SOURCE_DIR})
        endif ()
        set(FETCHCONTENT_BASE_DIR ${FETCHCONTENT_BASE_DIR_SAVE})
    else ()
        message(FATAL_ERROR
                "Microhs location was not specified. Please set MICROHS_PATH or set MICROHS_FETCH_FROM_GIT to on to fetch from git."
                )
    endif ()
endif ()

get_filename_component(MICROHS_PATH "${MICROHS_PATH}" REALPATH BASE_DIR "${CMAKE_BINARY_DIR}")
if (NOT EXISTS ${MICROHS_PATH})
    message(FATAL_ERROR "Directory '${MICROHS_PATH}' not found")
endif ()

set(MICROHS_MAKE_FILE ${MICROHS_PATH}/Makefile)
if (NOT EXISTS ${MICROHS_MAKE_FILE})
    message(FATAL_ERROR "Directory '${MICROHS_PATH}' does not appear to contain MicroHs")
endif ()

set(MICROHS_PATH ${MICROHS_PATH} CACHE PATH "Path to MicroHs" FORCE)


# macro(microhs_init)
#   if (NOT CMAKE_PROJECT_NAME)
#       message(WARNING "pico_sdk_init() should be called after the project is created (and languages added)")
#   endif()
#   add_custom_command(OUTPUT ${MICROHS_PATH}/bin/mhs
#     COMMAND make bin/mhs
#     WORKING_DIRECTORY ${MICROHS_PATH}
#   )
# endmacro()
