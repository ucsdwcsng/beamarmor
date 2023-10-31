# Locate FLTK library and include directories
find_path(FLTK_INCLUDE_DIR
  NAMES Fl/Fl.H
  PATH_SUFFIXES FL
  PATHS
    /usr/include
    /usr/local/include
)

find_library(FLTK_LIBRARY
  NAMES fltk
  PATHS
    /usr/lib
    /usr/local/lib
)

# Set the FLTK_INCLUDE_DIR and FLTK_LIBRARY variables if found
if (FLTK_INCLUDE_DIR AND FLTK_LIBRARY)
  set(FLTK_FOUND TRUE)
  set(FLTK_INCLUDE_DIRS ${FLTK_INCLUDE_DIR})
  set(FLTK_LIBRARIES ${FLTK_LIBRARY})
  message(STATUS "Found FLTK: ${FLTK_INCLUDE_DIR}, ${FLTK_LIBRARY}")
else ()
  set(FLTK_FOUND FALSE)
endif ()

mark_as_advanced(FLTK_INCLUDE_DIR FLTK_LIBRARY FLTK_FOUND)