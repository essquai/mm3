# Needed to compile bootstrap.
add_library(set STATIC)
include(sources.lst)
target_sources(set PRIVATE ${mm3_SOURCES})
