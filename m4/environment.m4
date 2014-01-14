AC_DEFUN([ENVIRONMENT],
[
	OS="$(uname -s)"
	if test "${OS}" = "AIX"; then
		CPPFLAGS="${CPPFLAGS} -DAIX"
	fi
	if test "${OS}" = "Linux"; then
		CPPFLAGS="${CPPFLAGS} -DLINUX"
	fi
	if test "${FINTP_HOME}" = ""; then
		FINTP_HOME="$(cd ..;pwd)"
		AC_MSG_WARN([FINTP_HOME variable not set. Assuming FINTP_HOME is ${FINTP_HOME}])
	fi
])
