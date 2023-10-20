#include <stdio.h>
#include <sched.h>
#include <sys/types.h>

int main() {
    pid_t pid = 0;
    int policy = SCHED_FIFO;
    int sched_priority = sched_get_priority_max(policy);

    struct sched_param param = {
        .sched_priority = sched_priority
    };

    int ret = sched_setscheduler(pid, policy, &param);
    if (ret == 0) {
        printf("sched_setscheduler: Ok\n");
    } else {
        perror("sched_setscheduler");
    }

    return 0;
}

