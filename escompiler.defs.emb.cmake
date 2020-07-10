if(BORLAND AND EMBARCADERO)

  set(binarySuffix ecc)
  if("${CMAKE_CXX_COMPILER_VERSION}" MATCHES "^([0-9]+)\\.([0-9]+)")
    math(EXPR compilerVersion "${CMAKE_MATCH_1}*100 + ${CMAKE_MATCH_2}")  
  endif()
  
  if(compilerVersion STRLESS "7300")
    message(
      FATAL_ERROR,
      "EMB compiler version ${compilerVersion} is not supported"
    )
  elseif(compilerVersion STRLESS "7400")
    set(compilerVersion 25)
  elseif(compilerVersion STRLESS "7500")
    set(compilerVersion 26)
  else()
    message(
      FATAL_ERROR,
      "EMB compiler version ${compilerVersion} is not supported"
    )
  endif()
  
  set(ESCOMMON_COMPILER_VERSION ${compilerVersion})
  set(ESCOMMON_BIN_SUFFIX ${binarySuffix})  
  
endif()