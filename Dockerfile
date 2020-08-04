# define
ARG BASE_TAG
FROM b01t/docker:${BASE_TAG}
LABEL maintainer "bolt@dhampir.no"


# required runtime
RUN set -eux                                                            &&  \
    export TERM=dumb DEBIAN_FRONTEND=noninteractive                     &&  \
    apt-get update                                                      &&  \
    apt-get install -y --no-install-recommends                              \
        jq                                                                  \
        timelimit                                                           \
        openssh-client                                                      \
        iproute2                                                            \
        uuid-runtime                                                        \
        avahi-utils                                                     &&  \

# preferences
    mkdir -m 700 /mnt/data                                              &&  \

# cleanup and space saving
    clean-dock


# scripts
COPY scripts/ /usr/local/bin/


# data directory
ENV DATA="/mnt/data"
VOLUME /mnt/data


# health
#HEALTHCHECK --start-period=10s --retries=3 --interval=30s --timeout=30s      \
#    CMD [ "curl", "--header", "X-Intent: Watchdog", "http://localhost/" ]


# environment
ENV \
    DELAY=60 \
    QUIET=false \
    HURRY=false


# run!
ENV ROOT=true
CMD ["/usr/local/bin/launch"]



# vim: tabstop=4:softtabstop=4:shiftwidth=4:expandtab
