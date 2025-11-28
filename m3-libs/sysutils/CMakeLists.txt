# Needed to compile bootstrap.
add_library(sysutils STATIC)
include(sources.lst)
target_sources(sysutils PRIVATE ${mm3_SOURCES})
