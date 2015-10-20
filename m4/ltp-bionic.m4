dnl
dnl Android/Bionic
dnl

dnl
dnl LTP_CHECK_BIONIC
dnl ---------------------
dnl
AC_DEFUN([LTP_CHECK_BIONIC],
[dnl
AC_ARG_WITH(
  [bionic],
  [AC_HELP_STRING([--with-bionic],
    [use LTP for Android bionic (default=yes)])],
  [with_bionic=yes],
  [with_bionic=no]
)

if test "x$with_bionic" = xyes; then
  AC_SUBST([BIONIC], 1)
else
  AC_SUBST([BIONIC], 0)
fi
])
