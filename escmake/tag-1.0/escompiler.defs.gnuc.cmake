if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  
  if(MINGW)
    set(binarySuffix mingw)
  else(MINGW)
    set(binarySuffix gcc)
  endif(MINGW)
  
  set(compilerVersion ${CMAKE_CXX_COMPILER_VERSION})
  
  set(ESCOMMON_COMPILER_VERSION ${compilerVersion})
  set(ESCOMMON_BIN_SUFFIX ${binarySuffix})  
  
endif()