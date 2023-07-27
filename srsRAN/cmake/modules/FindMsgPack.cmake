# FindMsgPack.cmake
#
# This module defines
#   MSGPACK_FOUND        - True if MsgPack found.
#   MSGPACK_INCLUDE_DIRS - The directory where the MsgPack headers are located.
#   MSGPACK_LIBRARIES    - The libraries needed to use MsgPack.

# First, try pkg-config to find MsgPack
find_package(PkgConfig REQUIRED)
pkg_check_modules(MSGPACK_PKG REQUIRED msgpack)

# If pkg-config did not find MsgPack, try manually looking for it
if(NOT MSGPACK_PKG_FOUND)
    find_path(MSGPACK_INCLUDE_DIRS
            NAMES msgpack.hpp
            PATHS /usr/include
            /usr/local/include
            )

    find_library(MSGPACK_LIBRARIES
            NAMES msgpackc
            PATHS /usr/lib
            /usr/local/lib
            /usr/lib/x86_64-linux-gnu/
            )

    if(MSGPACK_INCLUDE_DIRS AND MSGPACK_LIBRARIES)
        set(MSGPACK_FOUND TRUE CACHE INTERNAL "libMsgPack found")
        message(STATUS "Found libMsgPack: ${MSGPACK_INCLUDE_DIRS}, ${MSGPACK_LIBRARIES}")
    else(MSGPACK_INCLUDE_DIRS AND MSGPACK_LIBRARIES)
        set(MSGPACK_FOUND FALSE CACHE INTERNAL "libMsgPack found")
        message(STATUS "libMsgPack not found.")
    endif(MSGPACK_INCLUDE_DIRS AND MSGPACK_LIBRARIES)
endif(NOT MSGPACK_PKG_FOUND)

# If MsgPack is found, set include directories and libraries
if(MSGPACK_FOUND)
    set(MSGPACK_INCLUDE_DIRS ${MSGPACK_PKG_INCLUDE_DIRS} CACHE INTERNAL "")
    set(MSGPACK_LIBRARIES ${MSGPACK_PKG_LIBRARIES} CACHE INTERNAL "")
    mark_as_advanced(MSGPACK_LIBRARIES MSGPACK_INCLUDE_DIRS)
endif(MSGPACK_FOUND)