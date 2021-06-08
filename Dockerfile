FROM debian:buster-slim

ENV VER=v4.3.0-pre.2
ENV THELOUNGE_HOME="/config"
ENV PORT 9000
ENV PUID=1000
ENV PGID=1000
ENV UMASK=0000
ENV USER=thelounge


HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:9000 || exit 1

RUN apt-get update && \
        apt-get -y install --no-install-recommends curl screen procps && \
        curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
        apt-get -y install --no-install-recommends npm && \
        npm install --global --unsafe-perm thelounge@next && \
        npm install npm@latest -g && \
        rm -rf /var/lib/apt/lists/*

WORKDIR /app

EXPOSE ${PORT}


RUN useradd -d $THELOUNGE_HOME -s /bin/bash $USER && \
        usermod -u ${PUID} $USER && \
        usermod -g ${PGID} $USER

RUN mkdir -p /config/ && \
        chown -R $USER:$USER $THELOUNGE_HOME

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chown -R $USER:$USER /usr/local/bin/docker-entrypoint.sh && \
        chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
