# Needed to compile bootstrap.
add_executable(mm3)
install(TARGETS mm3)

target_link_libraries(mm3 PRIVATE
   Threads::Threads
   m3back
   m3front
   m3linker
   m3objfile
   m3quake
   set
   sysutils
)

include(sources.lst)
target_sources(mm3 PRIVATE ${mm3_SOURCES})
