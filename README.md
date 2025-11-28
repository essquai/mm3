# mm3
The Modded Modula-3 compiler is derived from [Critical Mass Modula-3](https://github.com/modula3/cm3) and includes
a a couple of minor packaging related enhancements.

## Quake
**mm3** incorporates two new m3makefile/quake builtins.
### require( *URI*, *VERSION* )
This builtin is a superset of existing import directive. If the package referenced by the given *URI* and *VERSION*
is already installed at your site, it is imported. If not, it will be be fetched, built, and
installed - and then imported. The *URI* may be of the form:
* files://*root*/pkg
* fossil://*site*/pkg
* git://*site*/pkg
* hg://*site*/pkg

where *root* is an absolute local directory name, *site* is the domain of a fossil/git/mercury server, and pkg is the
repository name. The *VERSION* parameter pulls a specific version dependency from
the Distributed Version Control Server repo; for files, it is simply appended to the installed package name if
not the empty string.

Yes - *require* is a keyword also used in *go.mod* files.
### cpp_source( "name" )
This builtin incorporates a C++ file into your Modula-3 library or program. As Modula-3 links directly to C functions
with the  EXTERNAL compiler pragma, such functions embedded in *extern "C" {}* .cpp files may in turn invoke C++ entry points.

It enables your Modula-3 projects to link with C++.

## mm3 packaging script

Packaging for mm3 boils down to a single script: mm3pkg.py. It can create three types of archive files. Most importantly it
creates an installation archive from source. It can also create a source distribution. Finally, since mm3 is a Modula-3 compiler
written in Modula-3, it can create a bootstrap package consisting of mm3 itself compiler to C bootstrap source code.

**mm3** only includes the compiler from cm3. The fourth and final piece of this packaging script will
install packages from the [cm3 fork](https://github.com/essquai/cm3) to your mm3 site installation.

## LLVM backend
The LLVM release 18 backend included in cm3 didn't compile. On one hand, the version in mm3 was mangled enough to
compile and build. Other hand it doesn work, has appearance of a linkage incompatibility between the gcc and llvm worlds.
Building mm3 purely with *clang* actually makes the problem worse, not better.

This LLVM backend code included simply to serve as a reference
for other or perhaps simpler intermediate representation back ends.
