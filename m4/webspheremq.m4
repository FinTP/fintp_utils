AC_DEFUN([WEBSPHEREMQ],
[
AC_ARG_WITH(wmq,
	    AS_HELP_STRING([--with-wmq@<:@=ARG@:>@],[Use WMQ from a standard location
		(ARG=yes), from a given location (ARG=<path>) or disable it (ARG=no). Default is no]),
	[
	if test $withval != yes; then
		WMQ_HOME=$withval;
	fi
	use_wmq=yes
	],
	WMQ_HOME=""; use_wmq=no)

	WMQ_CPPFLAGS=""
	WMQ_LDFLAGS=""	
	WMQ_LIBS=""

	if test $use_wmq = yes; then

	    CPPFLAGS_SAVE="${CPPFLAGS}"
	    LDFLAGS_SAVE="${LDFLAGS}"
	    LIBS_SAVE="${LIBS}"
		
		OS="$(uname -s)"

		if test $OS = "AIX"; then
			WMQ_LIBS="-limqb23ia_r -limqc23ia_r"
		else
			WMQ_LIBS="-limqb23gl_r -limqc23gl_r"
		fi

		if test "$WMQ_BITS" = "";
		then
			AC_COMPUTE_INT([pointer_size], [sizeof(void*)])
			WMQ_BITS=$(expr $pointer_size \* 8)	
		fi

	    if test "$WMQ_HOME" != ""; then
			WMQ_CPPFLAGS="-I${WMQ_HOME}/inc"
			if test $WMQ_BITS = "32"; then
				WMQ_LDFLAGS="-L${WMQ_HOME}/lib"
			else
				WMQ_LDFLAGS="-L${WMQ_HOME}/lib${WMQ_BITS}"
			fi
	    fi

	    AC_MSG_CHECKING(for IBM WebsphereMQ)
		
	    CPPFLAGS="${CPPFLAGS} ${WMQ_CPPFLAGS}"		
	    LDFLAGS="${LDFLAGS} ${WMQ_LDFLAGS}"
	    LIBS="${LIBS} ${WMQ_LIBS}"

	    AC_LANG_PUSH([C++])
	    AC_LINK_IFELSE(
	    [AC_LANG_PROGRAM([
			@%:@include <imqque.hpp>
			@%:@include <cmqc.h>
			],
			[ImqQueue q;]
			)],
			have_wmq=yes, have_wmq=no)
	    AC_LANG_POP([C++])

	    if test $have_wmq = no; then
	   	 AC_MSG_RESULT(no)
	    	AC_MSG_ERROR([Cannot build without WebsphereMQ])
	    fi

	    CPPFLAGS="${CPPFLAGS_SAVE}"
	    LDFLAGS="${LDFLAGS_SAVE}"
	    LIBS="${LIBS_SAVE}"
	    
	    WMQ_CPPFLAGS="${WMQ_CPPFLAGS} -DHAVE_WMQ -DWMQ_7"

	    AC_SUBST([WMQ_CPPFLAGS])
	    AC_SUBST([WMQ_LDFLAGS])
	    AC_SUBST([WMQ_LIBS])

	    AC_MSG_RESULT(yes)	
    fi
]
)
