AC_PREREQ([2.63])
AC_INIT([fintp_utils], [0.0.1])
AC_CONFIG_SRCDIR([src/Collections.cpp])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])

AC_PROG_CXX
AC_PROG_CC
AC_PROG_CPP
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_LIBTOOL

AM_INIT_AUTOMAKE

AC_CHECK_HEADERS([malloc.h stdlib.h string.h sys/param.h sys/timeb.h unistd.h], [], [Cannot build])

AC_CHECK_FUNCS([ftime gethostbyaddr gethostbyname gethostname memset strerror strtol strtoul uname], [], [Cannot build])

ENVIRONMENT

AX_PTHREAD(, [AC_MSG_ERROR([Cannot build without pthread]) ])

AX_BOOST_BASE([1.48.0], , [AC_MSG_ERROR([Cannot build without Boost])])

AX_LIB_XERCES([2.8.0])
	
if test $HAVE_XERCES != yes; then
	AC_MSG_ERROR([Cannot build without Xerces])
fi

AC_CONFIG_FILES([Makefile])

AC_OUTPUT
