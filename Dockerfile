# define
FROM debian:buster-slim
LABEL maintainer "bolt@dhampir.no"

SHELL ["/bin/bash", "-c"]

# required runtime
RUN set -eux                                                            &&  \
    export TERM=dumb DEBIAN_FRONTEND=noninteractive                     &&  \
    apt-get update                                                      &&  \
    apt-get install -y                                                      \
        bash                                                                \
        curl                                                                \
        timelimit                                                           \
        openssh-client                                                      \
        iproute2                                                            \
        avahi-utils                                                     &&  \

# docker
	curl -fsSL https://get.docker.com -o /tmp/get-docker.sh				&&	\
	sh /tmp/get-docker.sh												&&	\

# preferences
    mkdir -m 700 /mnt/data                                              &&  \

# cleanup and space saving
    apt-get clean                                                       &&  \
    for dir in /var/lib/{apt/lists,aptitude} /tmp /var/tmp; do              \
        [[ -d "$dir" ]] || continue;                                        \
        find "$dir" -mindepth 1 -print -delete;                             \
    done


# sync
COPY --chown=0:0 sync /cathedral


# scripts
COPY scripts/ /usr/local/bin/


# data directory
ENV DATA="/mnt/data"
VOLUME /mnt/data


# health
#HEALTHCHECK --start-period=10s --retries=3 --interval=30s --timeout=30s      \
#    CMD [ "curl", "--header", "X-Intent: Watchdog", "http://localhost/" ]


# run!
ENV DELAY=60
CMD ["/usr/local/bin/launch"]



# vim: tabstop=4:softtabstop=4:shiftwidth=4:expandtab
