# Common ES cmake definitions
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
