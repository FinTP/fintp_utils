ACLOCAL_AMFLAGS = -I m4

AM_CPPFLAGS = -DUNIX	\
@CPPFLAGS@	\
@PTHREAD_CFLAGS@	\
@BOOST_CPPFLAGS@ \
@XERCES_CPPFLAGS@

lib_LTLIBRARIES = libfintp_utils.la

AUTOMAKE_OPTIONS = foreign

libfintp_utils_la_LDFLAGS = @LIBS@ @LDFLAGS@	\
@PTHREAD_LIBS@	\
@XERCES_LDFLAGS@ -lxerces-c

libfintp_utils_la_SOURCES = src/Base64.cpp	\
src/Collaboration.cpp	\
src/Collections.cpp	\
src/PlatformDeps.cpp	\
src/StringUtil.cpp	\
src/TimeUtil.cpp	\
src/WorkItemPool.cpp	\
src/XmlUtil.cpp

nobase_include_HEADERS = src/Base64.h	\
src/CacheManager.h	\
src/Collaboration.h	\
src/Collections.h	\
src/Log.h	\
src/PlatformDeps.h	\
src/StringUtil.h	\
src/TimeUtil.h	\
src/ThreadingUtils.h	\
src/WorkItemPool.h	\
src/XmlUtil.h

SUBDIRS = .
