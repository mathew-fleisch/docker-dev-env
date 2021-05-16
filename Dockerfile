FROM ubuntu:20.04
LABEL maintainer="Mathew Fleisch <mathew.fleisch@gmail.com>"

ENV ASDF_DATA_DIR /opt/asdf
# Install apt dependencies
RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
    && apt update \
    && apt upgrade -y \
    && apt install -y curl wget apt-utils python3 python3-pip make build-essential openssl lsb-release libssl-dev apt-transport-https ca-certificates iputils-ping git vim zip \
    && apt-get clean \
    && python3 -m pip install --upgrade --force pip \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && git clone https://github.com/asdf-vm/asdf.git ${ASDF_DATA_DIR} --branch v0.8.0 \
    && echo "export ASDF_DATA_DIR=${ASDF_DATA_DIR}" | tee -a /root/.bashrc \
    && echo ". ${ASDF_DATA_DIR}/asdf.sh" | tee -a /root/.bashrc

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
