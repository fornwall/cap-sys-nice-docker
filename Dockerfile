FROM debian:bullseye-slim AS builder
COPY ./set-scheduler.c /
RUN apt-get update && \
    apt-get --yes install gcc && \
    gcc -Wall -Wextra -Werror -o set-scheduler set-scheduler.c

FROM debian:bullseye-slim
COPY --from=builder /set-scheduler /
COPY /entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
