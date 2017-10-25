 #    Copyright (c) 2010-2017, Delft University of Technology
 #    All rigths reserved
 #
 #    This file is part of the Tudat. Redistribution and use in source and
 #    binary forms, with or without modification, are permitted exclusively
 #    under the terms of the Modified BSD license. You should have received
 #    a copy of the license with this file. If not, please or visit:
 #    http://tudat.tudelft.nl/LICENSE.
 #
 #    References
 #      FindEigen3.cmake (2-clause BSD license)
 #
 #    Notes
 #	    Sets the following variables:
 #          PAGMO_INCLUDE_DIR    - Source directory to include
 #   	    PAGMO_VERSION        - PaGMO version found e.g. 2.4.0
 #   	    PAGMO_VERSION_MAJOR  - PaGMO major version found e.g. 2
 #   	    PAGMO_VERSION_MINOR  - PaGMO minor version found e.g. 4

macro(_pagmo_check_version)

    message(STATUS "Checking for PaGMO2 in: ${PAGMO_BASE_PATH}" )

    # Reads the version from a file in the base folder
    file(READ "${PAGMO_BASE_PATH}/CMakeLists.txt" _pagmo_cmake)

    STRING(REGEX REPLACE "^.*PAGMO_PROJECT_VERSION ([0-9]+)\\.[0-9]+" "\\1" PAGMO_VERSION_MAJOR "${_pagmo_cmake}")
    STRING(REGEX REPLACE "^.*PAGMO_PROJECT_VERSION [0-9]+\\.([0-9]+)" "\\1" PAGMO_VERSION_MINOR "${_pagmo_cmake}")
    set(PAGMO_VERSION ${PAGMO_VERSION_MAJOR}.${PAGMO_VERSION_MINOR})

    # Only check version if a required is set.
    if(PaGMO_FIND_VERSION)
        if(${PAGMO_VERSION} VERSION_LESS ${PaGMO_FIND_VERSION})
            set(PAGMO_VERSION_OK FALSE)
        else(${PAGMO_VERSION} VERSION_LESS ${PaGMO_FIND_VERSION})
            set(PAGMO_VERSION_OK TRUE)
        endif(${PAGMO_VERSION} VERSION_LESS ${PaGMO_FIND_VERSION})
    else(PaGMO_FIND_VERSION)
        set(PAGMO_VERSION_OK TRUE)
    endif(PaGMO_FIND_VERSION)

    if(NOT PAGMO_VERSION_OK)
        message(STATUS "PaGMO version ${PAGMO_VERSION} found in ${PAGMO_INCLUDE_DIR}, "
                   "but at least version ${PaGMO_FIND_VERSION} is required!")
    endif(NOT PAGMO_VERSION_OK)

    #Set include directories
    set(PAGMO_INCLUDE_DIR "${PAGMO_BASE_PATH}/include/;${PAGMO_BASE_PATH}/build/include/")
endmacro(_pagmo_check_version)

# If already set, skip this this
if(PAGMO_BASE_PATH)
  set(PAGMO_BASE_PATH_INIT ON)
else (PAGMO_BASE_PATH)

    # Look for file in possible locations
    find_path(PAGMO_BASE_PATH NAMES pagmo-config.cmake.in
      PATHS
      ${CMAKE_SOURCE_DIR}/pagmo2
      ${CMAKE_SOURCE_DIR}/../pagmo2
      ${CMAKE_SOURCE_DIR}/../../../pagmo2
      ${CMAKE_SOURCE_DIR}/../../../../pagmo2
      ${CMAKE_SOURCE_DIR}/../../../../../pagmo2
    )

    # Advance
    if(PAGMO_BASE_PATH)
	  set(PAGMO_BASE_PATH_INIT ON)
	else(PAGMO_BASE_PATH)
	  message(SEND_ERROR "Couldn't find PaGMO2 directory!")
    endif()

    mark_as_advanced(PAGMO_BASE_PATH)

endif(PAGMO_BASE_PATH)

if(PAGMO_BASE_PATH_INIT)
    _pagmo_check_version()
    set(FOUND_PAGMO ${PAGMO_VERSION_OK})
endif(PAGMO_BASE_PATH_INIT)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PaGMO DEFAULT_MSG PAGMO_INCLUDE_DIR PAGMO_VERSION_OK)
