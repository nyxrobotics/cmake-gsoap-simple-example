#
# This module detects if gsoap is installed and determines where the
# include files and libraries are.
#
# This code sets the following variables:
#
# GSOAP_IMPORT_DIR      = full path to the gsoap import directory
# GSOAP_LIBRARIES       = full path to the gsoap libraries
# GSOAP_SSL_LIBRARIES   = full path to the gsoap ssl libraries
# GSOAP_INCLUDE_DIR     = include dir to be used when using the gsoap library
# GSOAP_WSDL2H          = wsdl2h binary
# GSOAP_SOAPCPP2        = soapcpp2 binary
# GSOAP_FOUND           = set to true if gsoap was found successfully
#
# GSOAP_ROOT
#   setting this enables search for gsoap libraries / headers in this location

# -----------------------------------------------------
# GSOAP Import Directories
# -----------------------------------------------------
find_path(
  GSOAP_IMPORT_DIR
  NAMES wsa.h
  PATHS ${GSOAP_ROOT}/import
        ${GSOAP_ROOT}/share/gsoap/import
        /usr/share/gsoap/import
)
message("GSOAP_IMPORT_DIR:${GSOAP_IMPORT_DIR}")
# -----------------------------------------------------
# GSOAP Libraries
# -----------------------------------------------------
find_library(
  GSOAP_C_LIBRARIES NO_DEFAULT_PATH
  NAMES gsoap GSOAP
  PATHS ${GSOAP_ROOT}/lib
        ${GSOAP_ROOT}/lib64
        ${GSOAP_ROOT}/lib32
        /usr
        /usr/lib
        /usr/lib/x86_64-linux-gnu
  DOC "GSOAP library"
)
message("GSOAP_C_LIBRARIES:${GSOAP_C_LIBRARIES}")

find_library(
  GSOAP_SSL_C_LIBRARIES
  NAMES gsoapssl GSOAPSSL
  PATHS ${GSOAP_ROOT}/lib
        ${GSOAP_ROOT}/lib64
        ${GSOAP_ROOT}/lib32
        /usr
        /usr/lib
        /usr/lib/x86_64-linux-gnu
  DOC "GSOAPSSL library"
)
message("GSOAP_SSL_C_LIBRARIES:${GSOAP_SSL_C_LIBRARIES}")

find_library(
  GSOAP_CK_C_LIBRARIES
  NAMES gsoapck GSOAPCK
  PATHS ${GSOAP_ROOT}/lib
        ${GSOAP_ROOT}/lib64
        ${GSOAP_ROOT}/lib32
        /usr
        /usr/lib
        /usr/lib/x86_64-linux-gnu
  DOC "GSOAPCK library"
)
message("GSOAP_CK_C_LIBRARIES:${GSOAP_CK_C_LIBRARIES}")

find_library(
  GSOAP_CXX_LIBRARIES
  NAMES gsoap++ GSOAP++
  PATHS ${GSOAP_ROOT}/lib
        ${GSOAP_ROOT}/lib64
        ${GSOAP_ROOT}/lib32
        /usr
        /usr/lib
        /usr/lib/x86_64-linux-gnu
  DOC "GSOAP++ library"
)
message("GSOAP_CXX_LIBRARIES:${GSOAP_CXX_LIBRARIES}")

find_library(
  GSOAP_SSL_CXX_LIBRARIES
  NAMES gsoapssl++ GSOAPSSL++
  PATHS ${GSOAP_ROOT}/lib
        ${GSOAP_ROOT}/lib64
        ${GSOAP_ROOT}/lib32
        /usr
        /usr/lib
        /usr/lib/x86_64-linux-gnu
  DOC "GSOAPSSL++ library"
)
message("GSOAP_SSL_CXX_LIBRARIES:${GSOAP_SSL_CXX_LIBRARIES}")
find_library(
  GSOAP_CK_CXX_LIBRARIES
  NAMES gsoapck++ GSOAPCK++
  PATHS ${GSOAP_ROOT}/lib
        ${GSOAP_ROOT}/lib64
        ${GSOAP_ROOT}/lib32
        /usr
        /usr/lib
        /usr/lib/x86_64-linux-gnu
  DOC "GSOAPCK++ library"
)
message("GSOAP_CL_CXX_LIBRARIES:${GSOAP_CK_CXX_LIBRARIES}")

# -----------------------------------------------------
# GSOAP Include Directories
# -----------------------------------------------------
find_path(
  GSOAP_INCLUDE_DIR
  NAMES stdsoap2.h
  HINTS ${GSOAP_ROOT}
        ${GSOAP_ROOT}/include
        ${GSOAP_ROOT}/include/*
        /usr/include
  DOC "The gsoap include directory"
)

message("GSOAP_INCLUDE_DIR:${GSOAP_INCLUDE_DIR}")
# -----------------------------------------------------
# GSOAP Binaries
# ----------------------------------------------------
if(NOT GSOAP_TOOL_DIR)
  set(GSOAP_TOOL_DIR GSOAP_ROOT)
endif()

find_program(
  GSOAP_WSDL2H
  NAMES wsdl2h
  HINTS ${GSOAP_TOOL_DIR}/bin /usr/bin
  DOC "The gsoap bin directory"
)

message("GSOAP_WSDL2H:${GSOAP_WSDL2H}")
find_program(
  GSOAP_SOAPCPP2
  NAMES soapcpp2
  HINTS ${GSOAP_TOOL_DIR}/bin /usr/bin
  DOC "The gsoap bin directory"
)
message("GSOAP_SOAPCPP2:${GSOAP_SOAPCPP2}")
# -----------------------------------------------------
# GSOAP version
# try to determine the flagfor the 2.7.6 compatiblity, break with 2.7.13 and re-break with 2.7.16
# ----------------------------------------------------

message("GSOAP_STRING_VERSION:${GSOAP_STRING_VERSION}")
execute_process(
  COMMAND ${GSOAP_SOAPCPP2} "-V"
  OUTPUT_VARIABLE GSOAP_STRING_VERSION
  ERROR_VARIABLE GSOAP_STRING_VERSION
)
string(
  REGEX MATCH
        "[0-9]*\\.[0-9]*\\.[0-9]*"
        GSOAP_VERSION
        ${GSOAP_STRING_VERSION}
)
message("GSOAP_STRING_VERSION:${GSOAP_STRING_VERSION}")
# -----------------------------------------------------
# GSOAP_276_COMPAT_FLAGS and GSOAPVERSION
# try to determine the flagfor the 2.7.6 compatiblity, break with 2.7.13 and re-break with 2.7.16
# ----------------------------------------------------
if("${GSOAP_VERSION}"
   VERSION_LESS
   "2.7.6"
)
  set(GSOAP_276_COMPAT_FLAGS "")
elseif(
  "${GSOAP_VERSION}"
  VERSION_LESS
  "2.7.14"
)
  set(GSOAP_276_COMPAT_FLAGS "-z")
else(
  "${GSOAP_VERSION}"
  VERSION_LESS
  "2.7.14"
)
  set(GSOAP_276_COMPAT_FLAGS "-z1 -z2")
endif(
  "${GSOAP_VERSION}"
  VERSION_LESS
  "2.7.6"
)

# -----------------------------------------------------
# handle the QUIETLY and REQUIRED arguments and set GSOAP_FOUND to TRUE if
# all listed variables are TRUE
# -----------------------------------------------------
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  gsoap
  DEFAULT_MSG
  GSOAP_CXX_LIBRARIES
  GSOAP_C_LIBRARIES
  GSOAP_INCLUDE_DIR
  GSOAP_WSDL2H
  GSOAP_SOAPCPP2
)
mark_as_advanced(
  GSOAP_INCLUDE_DIR
  GSOAP_LIBRARIES
  GSOAP_WSDL2H
  GSOAP_SOAPCPP2
)

if(GSOAP_FOUND)
  if(GSOAP_FIND_VERSION)
    if(${GSOAP_VERSION}
       VERSION_LESS
       ${GSOAP_FIND_VERSION}
    )
      message("Found GSOAP version ${GSOAP_VERSION} less then required ${GSOAP_FIND_VERSION}.")
      unset(GSOAP_FOUND)
    endif()
  endif()
endif()
