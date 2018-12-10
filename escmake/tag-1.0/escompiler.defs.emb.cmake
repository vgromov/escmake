if(BORLAND AND EMBARCADERO)

  set(binarySuffix ecc)
  set(compilerVersion ${CMAKE_CXX_COMPILER_VERSION})
  
  string(
    REPLACE "." "_"
    ESCOMMON_COMPILER_VERSION 
    ${compilerVersion}
  )
  set(ESCOMMON_BIN_SUFFIX ${binarySuffix})  
  
endif()