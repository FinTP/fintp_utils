AC_DEFUN([UNIXODBC],
[
AC_ARG_WITH(unixodbc,
    AS_HELP_STRING([--without-unixodbc]) [Don't use UnixODBC],
    [
    unixodbc="no"
    ],
    [unixodbc="yes"]
    )

AC_ARG_WITH(unixodbc-inc,
    AS_HELP_STRING([--with-unixodbc-inc=PATH]) [Use UnixODBC headers from PATH ],
    [
    if test -d  $withval; then
        unixodbc_headers=$withval
    else
        AC_MSG_WARN([$withval doesn't exist])
        unixodbc_headers="no"
    fi
    ],
    [unixodbc_headers="no"]
    )

AC_ARG_WITH(unixodbc-lib,
    AS_HELP_STRING([--with-unixodbc-lib=PATH]) [Use UnixODBC libs from PATH ],
    [
    if test -d  $withval; then
        unixodbc_libs=$withval
    else
        AC_MSG_WARN([$withval doesn't exist])
        unixodbc_libs="no"
    fi
    ],
    [unixodbc_libs="no"]
    )

if test $unixodbc != "no"; then
    AC_MSG_CHECKING(for UnixODBC)
    
    if test $unixodbc_headers != "no";
    then
        CPPFLAGS="${CPPFLAGS} -I$unixodbc_headers"
    fi
    
    if test $unixodbc_libs != "no";
    then
	LDFLAGS="${LDFLAGS} -L$unixodbc_libs"
    fi

    LIBS="${LIBS} -lodbc"

    AC_LINK_IFELSE([
    AC_LANG_PROGRAM(
    [
    @%:@include <sql.h>
    ],
    [
    SQLHSTMT statement;
    SQLCancel(statement);
    ])
    ],
    [AC_MSG_RESULT(yes)],
    [AC_MSG_ERROR([Cannot build without UnixODBC])]
    )
fi
])
