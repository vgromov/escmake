if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  
  if(MINGW)
    set(binarySuffix mingw)
  else(MINGW)
    set(binarySuffix gcc)
  endif(MINGW)
  
  if("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "^([0-9]+)\\.([0-9]+)(?:\\.([0-9]+))?")
    math(EXPR compilerVersion "${CMAKE_MATCH_1}*1000 + ${CMAKE_MATCH_2}*10 + ${CMAKE_MATCH_3}")  
  endif()
  
  set(ESCOMMON_COMPILER_VERSION  ${compilerVersion})
  set(ESCOMMON_BIN_SUFFIX ${binarySuffix})
  
endif()