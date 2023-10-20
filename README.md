# cap-sys-nice-docker
Small docker image to experiment with [`CAP_SYS_NICE`](https://man7.org/linux/man-pages/man7/capabilities.7.html) in Docker.

The [entry point](entrypoint.sh) inspects `/proc/1/status` for `Cap*:` entries and then executes a [small C program](set-scheduler.c) that tries to call [sched_setscheduler](https://man7.org/linux/man-pages/man2/sched_setscheduler.2.html) to set the `SCHED_FIFO` "real-time" scheduling policy.

A x86-64 build is [published to docker hub](https://hub.docker.com/r/fredrikfornwall/cap-sys-nice-docker). To build locally:

```sh
$ docker build --tag fredrikfornwall/cap-sys-nice-docker:0.1 .
```

Run using docker directly:

```sh
$ docker run fredrikfornwall/cap-sys-nice-docker:0.1
Inspecting /proc/1/status
CapInh:	0000000000000000
CapPrm:	00000000a80425fb
CapEff:	00000000a80425fb
CapBnd:	00000000a80425fb
CapAmb:	0000000000000000
sched_setscheduler: Operation not permitted
```

As [CAP_SYS_NICE is bit 23](https://github.com/torvalds/linux/blob/master/include/uapi/linux/capability.h#L294C9-L294C21), we can verify that this bit is not set in `CapEff` here:

```sh
$ python3 -c 'print(0x00000000a80425fb & (1 << 23))'
0
```

Adding the capability:

```sh
$ docker run --cap-add SYS_NICE fredrikfornwall/cap-sys-nice-docker:0.1
Inspecting /proc/1/status
CapInh:	0000000000000000
CapPrm:	00000000a88425fb
CapEff:	00000000a88425fb
CapBnd:	00000000a88425fb
CapAmb:	0000000000000000
sched_setscheduler: Ok

$ python3 -c 'print(0x00000000a88425fb & (1 << 23))'
8388608
```

Deploy a [kubernetes pod](cap-sys-nice-docker.yml):

```sh
$ kubectl apply -f https://raw.githubusercontent.com/fornwall/cap-sys-nice-docker/main/cap-sys-nice-docker.yml
[..]
$ kubectl logs cap-sys-nice-docker
[..]
```

Note that this pod specifies the following security context for the container:

```yml
securityContext:
  capabilities:
    add: ["SYS_NICE"]
```
