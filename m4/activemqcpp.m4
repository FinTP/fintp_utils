AC_DEFUN([ACTIVEMQCPP],
[
AC_ARG_WITH([activemqcpp],
	[AS_HELP_STRING([--with-activemqcpp@<:@=ARG@:>@],
		[use ActiveMQ-CPP library from a standard location (ARG=yes),
		 disable (ARG=no) Default is yes ])],
	[
	if test $withval = no; then
		use_amq=no
	elif test $withval = yes; then
		use_amq=yes
	fi
	],
	[
	use_amq="yes"
	amq_include_path=""
	amq_lib_path=""
	])

AC_ARG_WITH([activemqcpp-lib],
	[AS_HELP_STRING([--with-activemqcpp-lib@<:@=ARG@:>@],
		[use ActiveMQ-CPP library from a given path (ARG=<path>)])],
	[
	use_amq=yes
	if test -d $withval; then
		amq_lib_path=$withval
	else
		AC_MSG_WARN([$withval doesn't exist. Will check standard library location for ActiveMQ-CPP])
		amq_lib_path=""
	fi
	],
	[amq_lib_path=""
	])

AC_ARG_WITH([activemqcpp-inc],
	[AS_HELP_STRING([--with-activemqcpp-inc@<:@=ARG@:>@],
		[use ActiveMQ-CPP headers from a given path (ARG=<path>)])],
	[
	use_amq=yes
	if test -d $withval; then
		amq_include_path=$withval
	else
		AC_MSG_WARN([$withval doesn't exist. Will check standard header location for ActiveMQ-CPP])
		amq_include_path=""
	fi
	],
	[amq_include_path=""
	])

AC_ARG_WITH([apr],
	[AS_HELP_STRING([--with-apr@<:@=PATH@:>@],
		[use APR from PATH])],
	[
	if test $use_amq = no; then
		AC_MSG_WARN([APR is only needed when using --with-activemqcpp])
	fi
	if test -d $withval; then
	apr_path=$withval
	else
		AC_MSG_WARN([$withval doesn't exist. Will check standard header location for APR])
		apr_path=""
	fi
	],
	[
	apr_path=""
	])

AMQ_CPPFLAGS=""
AMQ_LDFLAGS=""

if test $use_amq = yes; then

	CPPFLAGS_SAVE="${CPPFLAGS}"
	LDFLAGS_SAVE="${LDFLAGS}"

	AC_MSG_CHECKING(for Apache Portable Runtime (APR))
	found_apr=0

	dnl Try user provided path
	if test "$apr_path" != ""; then
		if ls $apr_path/bin/apr-*config &> /dev/null; then
			apr=$(ls $apr_path/bin/apr-*config)
			found_apr=1
		fi
	fi

	if test $found_apr = 0; then
		dnl Try default location
		for dir in /usr /usr/bin /usr/local /usr/local/bin  ; do
			if ls $dir/apr/bin/apr-*config &> /dev/null; then
				apr=$(ls $dir/apr/bin/apr-*config)
				found_apr=1
			fi
			if ls $dir/apr-*config &> /dev/null; then
				apr=$(ls $dir/apr-*config)
				found_apr=1
			fi
		done
	fi
	if test $found_apr = 1; then
		apr_includes=$($apr --includes)
		apr_libs=$($apr --link-ld --libs)
		AMQ_CPPFLAGS="${AMQ_CPPFLAGS} $apr_includes"
		AMQ_LDFLAGS="${AMQ_LDFLAGS} $apr_libs"
		AC_MSG_RESULT(yes)
	else
		AC_MSG_RESULT(no)
		AC_MSG_ERROR([APR was not found. APR is needed by ActiveMQ-CPP])
	fi

	if test "$amq_include_path" != "";then
		AMQ_CPPFLAGS="${AMQ_CPPFLAGS} -I$amq_include_path"
	fi
	if test "$amq_lib_path" != ""; then
		AMQ_LDFLAGS="${AMQ_LDFLAGS} -L$amq_lib_path"
	fi
	
	used_pkg_config=0

	activemqcpp-config --help &> /dev/null
	
	if test $? = 0; then
		AC_MSG_CHECKING(for ActiveMQ-CPP API >= 3.3)
		AMQ_CPPFLAGS="${AMQ_CPPFLAGS} $(activemqcpp-config --cflags)"
		AMQ_LDFLAGS="${AMQ_LDFLAGS} $(activemqcpp-config --libs)"
		version="$(activemqcpp-config --version)"
		major_ver=${version%%.*}
		minor_ver=${version#*.}
		minor_ver=${minor_ver%%.*}
		if test $major_ver -lt 3 || (test $major_ver -eq 3 && test $minor_ver -lt 3); then
			AC_MSG_RESULT(no)
			AC_MSG_ERROR([You have version $version of ActiveMQ-CPP. Please upgrade to a version greater than 3.3])
		fi
	else
	if test "$PKG_CONFIG" != "" && test "$PKG_CONFIG_PATH" != ""; then
		AC_WARN(activemqcpp-config not found. Will try searching using pkg-config)
		PKG_CHECK_MODULES([ACTIVEMQ], [activemq-cpp >= 3.3])
		AMQ_CPPFLAGS="${AMQ_CPPFLAGS} $ACTIVEMQ_CFLAGS"
		activemqcpp_lib_location=${ACTIVEMQ_LIBS%% *}
		AMQ_LDFLAGS="${AMQ_LDFLAGS} $activemqcpp_lib_location -lactivemq-cpp"
		used_pkg_config=1
	fi

	fi

	CPPFLAGS="${CPPFLAGS} ${AMQ_CPPFLAGS}"
	LDFLAGS="${LDFLAGS} ${AMQ_LDFLAGS}"

	AC_LANG_PUSH([C++])
	AC_LINK_IFELSE([
	AC_LANG_PROGRAM(
		[
		@%:@include <activemq/library/ActiveMQCPP.h>
		],
		[
		activemq::library::ActiveMQCPP::initializeLibrary();
		]
	)],
	[found=true],
	[found=false]
	)
	AC_LANG_POP([C++])
	if test $found = true;then

		CPPFLAGS="${CPPFLAGS_SAVE}"
		LDFLAGS="${LDFLAGS_SAVE}"

		AMQ_CPPFLAGS="${AMQ_CPPFLAGS} -DHAVE_AMQ"

		AC_SUBST([AMQ_CPPFLAGS])
		AC_SUBST([AMQ_LDFLAGS])

		if test $used_pkg_config = 0; then
			AC_MSG_RESULT(yes)
		fi
	else
		if test $used_pkg_config = 0; then
			AC_MSG_RESULT(no)
		fi
		AC_MSG_ERROR([ActiveMQ-CPP test failed!
		You either don't have ActiveMQ-CPP installed or you have an older version than 3.3.
		])
	fi
fi
]
)
