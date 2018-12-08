# Common linker configurations and defines
message(
  STATUS
  "Setting up C++ Runtime Linking"
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

  else()
  
    message(
      STATUS
      "MSVC -> Use MSVC statically-linked runtime."
    )
    
    foreach(variable ${compilerVars})
      if(variable MATCHES "/MD")
        string(REGEX REPLACE "/MD" "/MT" ${variable} "${${variable}}")
      endif()
    endforeach()
    
  endif()
  
elseif(CMAKE_COMPILER_IS_GNUCXX)

  if(NOT ES_USE_DYNAMIC_RUNTIME)
    message(
      STATUS
      "GNUCXX -> Linking against libstdc++ runtime statically"
    )
  
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++")
  else()
    message(
      STATUS
      "GNUCXX -> Linking against libstdc++ runtime dynamically"
    )
  endif()
  
  if(MINGW)
    set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -lmingw32")
  endif()
  
endif()
