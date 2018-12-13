if(BORLAND AND EMBARCADERO)

  set(binarySuffix ecc)
  if("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "^([0-9]+)\\.([0-9]+)")
    math(EXPR compilerVersion "${CMAKE_MATCH_1}*100 + ${CMAKE_MATCH_2}")  
  endif()
  
  string(
    REPLACE "." "_"
    ESCOMMON_COMPILER_VERSION 
    ${compilerVersion}
  )
  set(ESCOMMON_BIN_SUFFIX ${binarySuffix})  
  
endif()