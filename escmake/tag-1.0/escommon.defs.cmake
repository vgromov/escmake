# This file must be included at the top level CmakeLists.txt

# Common ES cmake definitions
get_filename_component(root ${PROJECT_BINARY_DIR} REALPATH)
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
set(ES_BUILD_SHARED_LIBS ON CACHE BOOL INTERNAL "")
set(ES_USE_DYNAMIC_RUNTIME ON CACHE BOOL INTERNAL "")

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
