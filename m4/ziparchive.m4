AC_DEFUN([ZIPARCHIVE],
[
AC_ARG_WITH(ziparchive,
	    AS_HELP_STRING([--with-ziparchive=DIR],[ZipArchive location]),
	    [ZIP_HOME=$withval;path=yes],[path=no])

AC_MSG_CHECKING(for ZipArchive)

 ZIP_LIBS="-lziparch"

 if test $path = yes; then
	ZIP_CPPFLAGS="-I${ZIP_HOME}"
	ZIP_LDFLAGS="-L${ZIP_HOME}"
 else
	ZIP_CPPFLAGS="-I/usr/include/ZipArchive -I/usr/local/ZipArchive/ZipArchive -I/usr/local/ZipArchive"
	ZIP_LDFLAGS="-L/usr/local/ZipArchive/ZipArchive -L/usr/local/ZipArchive"
 fi

 CPPFLAGS_SAVE="${CPPFLAGS}"
 LDFLAGS_SAVE="${LDFLAGS_SAVE}"
 LIBS_SAVE="${LIBS}"

 CPPFLAGS="${CPPFLAGS} ${ZIP_CPPFLAGS}"
 LDFLAGS="${LDFLAGS} ${ZIP_LDFLAGS}"
 LIBS="${LIBS} ${ZIP_LIBS}"

 AC_LANG_PUSH([C++])
 AC_COMPILE_IFELSE([
 AC_LANG_PROGRAM(
  [
	@%:@include "ZipMemFile.h"
  ],
  [
	CZipMemFile zipMemFile;
  ])
 ],
 [have_zip=true],
 [have_zip=false]
 )
 if test $have_zip = true; then
 AC_LINK_IFELSE([
 AC_LANG_PROGRAM(
  [
	@%:@include "ZipMemFile.h"
  ],
  [
	CZipMemFile zipMemFile;
  ])
 ],
 [],
 [AC_MSG_ERROR(ZipArchive headers found but ZipArchive library is missing.)]
 )
 AC_LANG_POP([C++])
 else
	    AC_MSG_RESULT(no)
	    if test $path = no; then
			AC_MSG_ERROR([I tried searching for ZipArchive and failed. Please provide path using --with-ziparchive=DIR])
	    fi
	    if test $path = yes; then
			AC_MSG_ERROR([The path you provided @{:@${ZIP_HOME}@:}@ doesn't contain ZipArchive])
	    fi
 fi
 AC_MSG_RESULT(yes)

 CPPFLAGS="${CPPFLAGS_SAVE}"
 LDFLAGS="${LDFLAGS_SAVE}"
 LIBS="${LIBS_SAVE}"

 AC_SUBST([ZIP_CPPFLAGS])
 AC_SUBST([ZIP_LDFLAGS])
 AC_SUBST([ZIP_LIBS])
]
)
