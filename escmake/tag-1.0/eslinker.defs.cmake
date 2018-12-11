# Common linker configurations and defines
message(
  STATUS
  "Setting up C++ Runtime Linking..."
)

if(MSVC)

  # Set MSVC linker options.
  set(compilerVars
    CMAKE_C_FLAGS_DEBUG
    CMAKE_C_FLAGS_MINSIZEREL
    CMAKE_C_FLAGS_RELEASE
    CMAKE_C_FLAGS_RELWITHDEBINFO
    CMAKE_CXX_FLAGS_DEBUG
    CMAKE_CXX_FLAGS_MINSIZEREL
    CMAKE_CXX_FLAGS_RELEASE
    CMAKE_CXX_FLAGS_RELWITHDEBINFO
  )

  if(ES_USE_DYNAMIC_RUNTIME)
  
    message(
      STATUS
      "MSVC -> Use MSVC dynamically-linked runtime."
    )
  
    foreach(variable ${compilerVars})
      if(variable MATCHES "/MT")
        string(REGEX REPLACE "/MT" "/MD" ${variable} "${${variable}}")
      endif()
    endforeach()

  else(ES_USE_DYNAMIC_RUNTIME)
  
    message(
      STATUS
      "MSVC -> Use MSVC statically-linked runtime."
    )
    
    foreach(variable ${compilerVars})
      if(variable MATCHES "/MD")
        string(REGEX REPLACE "/MD" "/MT" ${variable} "${${variable}}")
      endif()
    endforeach()
    
  endif(ES_USE_DYNAMIC_RUNTIME)
  
elseif(CMAKE_COMPILER_IS_GNUCXX)

  if(NOT ES_USE_DYNAMIC_RUNTIME)
    message(
      STATUS
      "GNUCXX -> Linking against libstdc++ runtime statically"
    )
  
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++")
  else(NOT ES_USE_DYNAMIC_RUNTIME)
    message(
      STATUS
      "GNUCXX -> Linking against libstdc++ runtime dynamically"
    )
  endif(NOT ES_USE_DYNAMIC_RUNTIME)
  
  if(MINGW)
    set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -lmingw32")
  endif(MINGW)
  
endif()

# Tune-up add_library behaviour
set(BUILD_SHARED_LIBS ${ES_BUILD_SHARED_LIBS})
message(
  STATUS
  "eslinker.defs BUILD_SHARED_LIBS=>${BUILD_SHARED_LIBS}"
)
