if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  
  if(MINGW)
    set(binarySuffix mingw)
  else(MINGW)
    set(binarySuffix gcc)
  endif(MINGW)
  
  if("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "^([0-9]+)\\.([0-9]+)\\.([0-9]+)")
    if( "${CMAKE_MATCH_2}" STRGREATER_EQUAL "10" )
      math(EXPR compilerVersion "${CMAKE_MATCH_1}*100 + ${CMAKE_MATCH_2}")
    else()
      math(EXPR compilerVersion "${CMAKE_MATCH_1}*100 + ${CMAKE_MATCH_2}*10 + ${CMAKE_MATCH_3}")  
    endif()
  endif()
  
  set(ESCOMMON_COMPILER_VERSION  ${compilerVersion})
  set(ESCOMMON_BIN_SUFFIX ${binarySuffix})
  
endif()
