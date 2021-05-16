FROM ubuntu:20.04
LABEL maintainer="Mathew Fleisch <mathew.fleisch@gmail.com>"

COPY scripts/getArch /usr/local/bin/getArch
ENV ASDF_DATA_DIR /opt/asdf
# Install apt dependencies
RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
    && apt update \
    && apt upgrade -y \
    && apt install -y curl wget apt-utils python3 python3-pip make build-essential openssl lsb-release libssl-dev apt-transport-https ca-certificates iputils-ping git vim zip sudo binfmt-support qemu-user-static \
    && curl -sSL https://get.docker.com/ | sh \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && apt-get clean \
    && apt-get dist-upgrade -u -y \
    && useradd -ms /bin/bash github \
    && usermod -aG sudo github \
    && adduser github docker \
    && usermod -aG docker github \
    && usermod -aG docker root \
    && python3 -m pip install --upgrade --force pip \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && mkdir -p $ASDF_DATA_DIR \
    && chmod -R g+w $ASDF_DATA_DIR \
    && git clone https://github.com/asdf-vm/asdf.git ${ASDF_DATA_DIR} --branch v0.8.0 \
    && echo "export ASDF_DATA_DIR=${ASDF_DATA_DIR}" | tee -a ~/.bashrc \
    && echo ". ${ASDF_DATA_DIR}/asdf.sh" | tee -a ~/.bashrc \
    && mkdir -p ~/.docker/cli-plugins \
    && wget $(curl -s https://api.github.com/repos/docker/buildx/releases/latest | jq -r .assets[].browser_download_url | grep $(getArch) | grep -v darwin) -O ~/.docker/cli-plugins/docker-buildx \
    && chmod +x ~/.docker/cli-plugins/docker-buildx \
    && docker buildx create --name mbuilder \
    && docker buildx use mbuilder \
    && docker buildx inspect --bootstrap

# Install asdf dependencies
WORKDIR /root
COPY .tool-versions /root/.
COPY scripts /root/scripts
COPY pin /root/.
COPY tests /root/tests
RUN chmod a+x /root/scripts/*.sh \
    && . ${ASDF_DATA_DIR}/asdf.sh  \
    && while IFS= read -r line; do dep=$(echo "$line" | sed 's/\ .*//g'); asdf plugin add $dep; done < .tool-versions \
    && asdf install

CMD /bin/bash -c '. ${ASDF_DATA_DIR}/asdf.sh && /bin/bash'
