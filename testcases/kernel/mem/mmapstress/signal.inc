#include <signal.h>
#include <stdlib.h>

int sighold(int sig)
{
	sigset_t set;

	sigemptyset(&set);
	sigaddset(&set, sig);
	return (sigprocmask(SIG_BLOCK, &set, NULL));
}

int sigrelse(int sig)
{
	sigset_t set;

	sigemptyset(&set);
	sigaddset(&set, sig);
	return (sigprocmask(SIG_UNBLOCK, &set, NULL));
}
