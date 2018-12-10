# Compiler definitions
set(ESCOMMON_COMPILER_VERSION "" CACHE INTERNAL "")
set(ESCOMMON_BIN_SUFFIX "" CACHE INTERNAL "")

include(${PROJECT_BINARY_DIR}/escmake/escompiler.defs.msvc.cmake)
include(${PROJECT_BINARY_DIR}/escmake/escompiler.defs.gnuc.cmake)
include(${PROJECT_BINARY_DIR}/escmake/escompiler.defs.emb.cmake)

# Check for compiler defs completion
if(compilerVersion STREQUAL "")
  message(
    FATAL_ERROR
    "compilerVersion is not defined"
  )
endif()

if(binarySuffix STREQUAL "")
  message(
    FATAL_ERROR
    "binarySuffix is not defined"
  )
endif()

# set-up 'system' compiler-specific variable(s)
message(
  STATUS 
  "ESCOMMON_COMPILER_VERSION=>${ESCOMMON_COMPILER_VERSION}; ESCOMMON_BIN_SUFFIX=>${ESCOMMON_BIN_SUFFIX}"
)

# Configure CPP standard
set(ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD "CPP11" CACHE STRING "Required minimum C++ standard, Default=C++11")
set_property(CACHE ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD PROPERTY STRINGS CPP11 CPP14 CPP17)

# Set-up common comiler flags based on configuration
if(CMAKE_VERSION VERSION_LESS "3.1")
  if( CMAKE_COMPILER_IS_GNUCXX )
    if( ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD STREQUAL "CPP11" )
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    elseif( ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD STREQUAL "CPP14" )
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
    elseif( ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD STREQUAL "CPP17" )
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    else()
      message(
        FATAL_ERROR
        "Undefined C++ standard version: ${ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD}"
      )
    endif()
  endif()
else()
  if( ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD STREQUAL "CPP11" )
    set(CMAKE_CXX_STANDARD 11)
  elseif( ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD STREQUAL "CPP14" )
    set(CMAKE_CXX_STANDARD 14)
  elseif( ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD STREQUAL "CPP17" )
    set(CMAKE_CXX_STANDARD 17)
  else()
    message(
      FATAL_ERROR
      "Undefined C++ standard version: ${ESCOMMON_CONFIG_REQUIRED_CPP_STANDARD}"
    )
  endif()
endif()

# Use UTF-8 source charset, to augment proper string literal encoding in GCC environment
if(CMAKE_COMPILER_IS_GNUCXX)
  list(APPEND CMAKE_CXX_FLAGS -finput-charset=UTF-8)
endif()

# Add global compiler-specific flags
if(MSVC)
  # Suppress msvc security warnings, assign explicit compiler version for wxWidgets
  set(CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} -D_CRT_SECURE_NO_WARNINGS -D_SCL_SECURE_NO_WARNINGS -DwxMSVC_VERSION=${ESCOMMON_COMPILER_VERSION}"
  )
endif()

# Global preprocessor defines
#
# Always use UNICODE builds
add_definitions(-DUNICODE -D_UNICODE)

if(ES_BUILD_SHARED_LIBS)
  # For dynamic linkage to ekosf core libraries
  set(ES_USEDLL_PREPROC_FOR_EXE ES_USE_DLLS)
 
  if(MSVC)
    # For dynamic linkage to ekosf core libraries and proper dll interface generation
    set(ES_USEDLL_PREPROC_FOR_DYNLIB ES_USE_DLLS _USRDLL)
  endif()
endif()
