#ifndef __BIONIC_H__
#define __BIONIC_H__

#ifdef BIONIC
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/syscall.h>

#define adjtimex(...) syscall(__NR_adjtimex, __VA_ARGS__)
#define msgctl(...) syscall(__NR_msgctl, __VA_ARGS__)
#define msgget(...) syscall(__NR_msgget, __VA_ARGS__)
#define msgrcv(...) syscall(__NR_msgrcv, __VA_ARGS__)
#define msgsnd(...) syscall(__NR_msgsnd, __VA_ARGS__)
#define semctl(...) syscall(__NR_semctl, __VA_ARGS__)
#define semop(...)  syscall(__NR_semop, __VA_ARGS__)
#define semget(...) syscall(__NR_semget, __VA_ARGS__)
#define shmctl(...) syscall(__NR_shmctl, __VA_ARGS__)
#define shmget(...) syscall(__NR_shmget, __VA_ARGS__)
#define shmat(...)  syscall(__NR_shmat, __VA_ARGS__)
#define shmdt(...)  syscall(__NR_shmdt, __VA_ARGS__)
#define ustat(...)  syscall(__NR_ustat, __VA_ARGS__)
#define remap_file_pages(...) syscall(__NR_remap_file_pages, __VA_ARGS__)

#define sigset(...) signal(__VA_ARGS__)

#define mallopt(arg1, arg2) do { } while (0);

#define S_IREAD S_IRUSR
#define S_IWRITE S_IWUSR

#ifndef __GLIBC_PREREQ
#define __GLIBC_PREREQ(x, y) 0
#endif

#define SHMLBA (4 * PAGE_SIZE)
#define SHM_LOCKED 02000 /* segment will not be swapped */
#define SHM_HUGETLB 04000 /* segment will use huge TLB pages */

#ifndef NGROUPS
#define NGROUPS NGROUPS_MAX
#endif

#ifndef MININT
#define MININT INT_MIN
#endif

typedef unsigned long ulong;

struct timeb {
	time_t          time;
	unsigned short  millitm;
	short           timezone;
	short           dstflag;
};

#endif /* BIONIC */
#endif /* __BIONIC_H__ */
