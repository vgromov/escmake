# This file must be included at the top level CMakeLists.txt

# Common ES cmake definitions
get_filename_component(root ${PROJECT_SOURCE_DIR} REALPATH)
set(ES_PROJECT_ROOT ${root} CACHE INTERNAL "Project root directory")
message(
  STATUS
  "ES_PROJECT_ROOT=>${ES_PROJECT_ROOT}"
)

# I18N integration internal globals
set(ESI18N_LANGUAGES "" CACHE INTERNAL "" FORCE)
set(ESI18N_DOMAINS "" CACHE INTERNAL "" FORCE)
set(ESI18N_PO_PATTERN ".+[.]([a-z][a-z]_[A-Z][A-Z])[.]po" CACHE INTERNAL "" FORCE)

# Linkage control internal global variables
set(ES_BUILD_SHARED_LIBS 1 CACHE INTERNAL "")
set(ES_USE_DYNAMIC_RUNTIME 1 CACHE INTERNAL "")

# Set-up header extensions, i.e. non-processable directly by compilation, rather, simply included into project tree
set(ES_HEADER_EXTENSIONS 
  .h 
  .hpp 
  .hxx 
  .ipp 
  .xpm 
  .cxx 
  .hmxz 
  .def 
  .inc 
  .cc 
  .pot 
  .ru_RU.po 
  .en_EN.po 
)

# precompiled header macro
MACRO(ES_SPECIFY_PRECOMPILED_HEADER PrecompiledHeader PrecompiledSource SourcesVar)
  if(MSVC)
    get_filename_component(PrecompiledBasename ${PrecompiledHeader} NAME_WE)
    set(PrecompiledBinary "$(IntDir)/${PrecompiledBasename}.pch")
    set(Sources ${${SourcesVar}})
    set_source_files_properties(${PrecompiledSource} PROPERTIES
      COMPILE_FLAGS "/Yc\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
      OBJECT_OUTPUTS "${PrecompiledBinary}")
    set_source_files_properties(${Sources}
      PROPERTIES COMPILE_FLAGS "/Yu\"${PrecompiledHeader}\" /FI\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
      OBJECT_DEPENDS "${PrecompiledBinary}")
    # Add precompiled header to SourcesVar
    list(APPEND ${SourcesVar} ${PrecompiledSource})
  else()
    # Just append source to SourcesVar, if do not know how to precompile
    list(APPEND ${SourcesVar} ${PrecompiledSource})
  endif()
ENDMACRO(ES_SPECIFY_PRECOMPILED_HEADER)

# header specification macro
MACRO(ES_SPECIFY_HEADER_FILES SourceFiles HeaderExtensions)
	foreach(f ${${SourceFiles}})
		get_filename_component(fExt ${f} EXT)
		list(FIND ${HeaderExtensions} "${fExt}" foundResult)
		if( ${foundResult} GREATER -1 )
			set(headersFound ${headersFound} ${f})
		endif()
	endforeach()
	set_source_files_properties(${headersFound} PROPERTIES
		HEADER_FILE_ONLY ON
	)
ENDMACRO(ES_SPECIFY_HEADER_FILES)

# localization integration macros
MACRO(ESI18N_ADD i18nComponent i18nFiles i18nBinaryRoot)
	# copy from cache
	set(tmpLanguages ${ESI18N_LANGUAGES})
	set(tmpComponents ${ESI18N_DOMAINS})
	# find if we already registered component
	list(FIND tmpComponents "${i18nComponent}" tmp)
	if( -1 EQUAL ${tmp} )
		list(APPEND tmpComponents "${i18nComponent}")
		# create component variables for bin dir and language files
		get_filename_component(binRoot "${i18nBinaryRoot}" REALPATH)
		set("${i18nComponent}_BinRoot" "${binRoot}" CACHE INTERNAL "" FORCE)
	endif()
	# analyse incoming i18n files list
	foreach(f ${${i18nFiles}})
		set(lang "")
		if("${f}" MATCHES "${ESI18N_PO_PATTERN}")
			string(REGEX REPLACE
							"${ESI18N_PO_PATTERN}" "\\1"
							lang "${f}")
			if( lang )
				list(FIND tmpLanguages ${lang} tmp)
				if( -1 EQUAL tmp )
					list(APPEND tmpLanguages "${lang}")
				endif()
				list(FIND "${i18nComponent}${lang}" "${PROJECT_SOURCE_DIR}/${f}" tmp)
				if( -1 EQUAL tmp )
					set(tmp "${${i18nComponent}${lang}}" "${PROJECT_SOURCE_DIR}/${f}")
					set("${i18nComponent}${lang}" ${tmp} CACHE INTERNAL "" FORCE)
				endif()
			endif()
		endif()
	endforeach()
	# update cache
	set(ESI18N_LANGUAGES ${tmpLanguages} CACHE STRING "" FORCE)
	set(ESI18N_DOMAINS ${tmpComponents} CACHE STRING "" FORCE)
ENDMACRO(ESI18N_ADD)

MACRO(ESI18N_TRACE)
	message(
    STATUS
    "I18N languages: ${ESI18N_LANGUAGES}"
  )
	message(
    STATUS
    "I18N components: ${ESI18N_DOMAINS}"
  )
	foreach(comp ${ESI18N_DOMAINS})
		message(
      STATUS 
      "I18N ${comp}_BinRoot: ${${comp}_BinRoot}"
    )
		foreach(lang ${ESI18N_LANGUAGES})
			message(
        STATUS
        "I18N ${comp}${lang} files: ${${comp}${lang}}"
      )
		endforeach()
	endforeach()
ENDMACRO(ESI18N_TRACE)

MACRO(ESI18N_RESET)
	foreach(comp ${ESI18N_DOMAINS})
		unset("${comp}_BinRoot" CACHE)
		foreach(lang ${ESI18N_LANGUAGES})
			unset("${comp}${lang}" CACHE)
		endforeach()
	endforeach()
	set(ESI18N_LANGUAGES "" CACHE INTERNAL "" FORCE)
	set(ESI18N_DOMAINS "" CACHE INTERNAL "" FORCE)
ENDMACRO(ESI18N_RESET)

MACRO(LIST_TO_STRING outVar listVar)
	foreach(s ${${listVar}})
		set(${outVar} "${s}|${${outVar}}")
	endforeach()
ENDMACRO(LIST_TO_STRING)

MACRO(ES_ADD_TO_SETUP_DEPENDENCIES targetName)
	set(setupDependencies ${setupDependencies} ${targetName} CACHE STRING "" FORCE)
ENDMACRO(ES_ADD_TO_SETUP_DEPENDENCIES)

# help and manual compiler
MACRO(ES_USE_HELP_AND_MANUAL)
  if(WIN32)
    if( NOT helpAndManualCompiler )
      find_program(helpAndManualCompiler
                helpman.exe
                PATHS "c:/program files" "c:/program files (x86)" ENV PATH
                PATH_SUFFIXES "EC Software/HelpAndManual5" "EC Software/HelpAndManual6"
        )
    endif()
    if( NOT helpAndManualCompiler )
      message(FATAL_ERROR
        "Help and manual compiler is not found"
      )
    endif()
  endif()
ENDMACRO(ES_USE_HELP_AND_MANUAL)

# generate newline-separated file list file from variable
MACRO(ES_GEN_FILELIST fileListName fileList)
	foreach(line ${${fileList}})
		string(
			APPEND
			fileListContents
			"${line}\n"
		)
	endforeach()

	file(
		WRITE
		${fileListName}
		${fileListContents}
	)
ENDMACRO(ES_GEN_FILELIST)

# execute reflection declarations and implementations generator for each header file in list
MACRO(ES_GENERATE_REFLECTION fileList)
	
	foreach(fitem ${${fileList}})
		get_filename_component(fdir ${fitem} DIRECTORY)
		get_filename_component(fname ${fitem} NAME)
		get_filename_component(fext ${fitem} EXT)
		if( ${fext} STREQUAL ".h" )
			execute_process(
				COMMAND
				cog -d -D STAGE=IMPL -o {fname}.reflection ${fname}
			)
#			cog -D STAGE=DECL ${fname}
		endif()
	endforeach()

ENDMACRO(ES_GENERATE_REFLECTION)