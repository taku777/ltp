#!/bin/sh

output="linux_syscall_numbers.h"
rm -f "${output}".[1-9]*
output_pid="${output}.$$"

max_jobs=$(getconf _NPROCESSORS_ONLN 2>/dev/null)
: ${max_jobs:=1}

srcdir=${0%/*}

err() {
	echo "$*" 1>&2
	exit 1
}

cat << EOF > "${output_pid}"
/************************************************
 * GENERATED FILE: DO NOT EDIT/PATCH THIS FILE  *
 *  change your arch specific .in file instead  *
 ************************************************/

/*
 * Here we stick all the ugly *fallback* logic for linux
 * system call numbers (those __NR_ thingies).
 *
 * Licensed under the GPLv2 or later, see the COPYING file.
 */

#ifndef __LINUX_SYSCALL_NUMBERS_H__
#define __LINUX_SYSCALL_NUMBERS_H__

#include <errno.h>
#include <sys/syscall.h>
#include "cleanup.c"

#define ltp_syscall(NR, ...) ({ \\
	int __ret; \\
	if (NR == __LTP__NR_INVALID_SYSCALL) { \\
		errno = ENOSYS; \\
		__ret = -1; \\
	} else { \\
		__ret = syscall(NR, ##__VA_ARGS__); \\
	} \\
	if (__ret == -1 && errno == ENOSYS) { \\
		tst_brkm(TCONF, CLEANUP, \\
			"syscall " #NR " not supported on your arch"); \\
		errno = ENOSYS; \\
	} \\
	__ret; \\
})

EOF

jobs=0
for arch in $(cat "${srcdir}/order") ; do
	(
	echo "Generating data for arch $arch ... "

	(
	echo
	case ${arch} in
		sparc64) echo "#if defined(__sparc__) && defined(__arch64__)" ;;
		sparc) echo "#if defined(__sparc__) && !defined(__arch64__)" ;;
		*) echo "#ifdef __${arch}__" ;;
	esac
	while read line ; do
		set -- ${line}
		nr="__NR_$1"
		shift
		if [ $# -eq 0 ] ; then
			err "invalid line found: $line"
		fi
		echo "# ifndef ${nr}"
		echo "#  define ${nr} $*"
		echo "# endif"
	done < "${srcdir}/${arch}.in"
	echo "#endif"
	echo
	) >> "${output_pid}.${arch}"

	) &

	: $(( jobs += 1 ))
	if [ ${jobs} -ge ${max_jobs} ] ; then
		wait || exit 1
		jobs=0
	fi
done

echo "Generating stub list ... "
(
echo
echo "/* Common stubs */"
echo "#define __LTP__NR_INVALID_SYSCALL -1" >> "${output_pid}"
for nr in $(awk '{print $1}' "${srcdir}/"*.in | sort -u) ; do
	nr="__NR_${nr}"
	echo "# ifndef ${nr}"
	echo "#  define ${nr} __LTP__NR_INVALID_SYSCALL"
	echo "# endif"
done
echo "#endif"
) >> "${output_pid}._footer"

wait || exit 1

printf "Combining them all ... "
for arch in $(cat "${srcdir}/order") _footer ; do
	cat "${output_pid}.${arch}"
done >> "${output_pid}"
mv "${output_pid}" "${output}"
rm -f "${output_pid}"*
echo "OK!"
