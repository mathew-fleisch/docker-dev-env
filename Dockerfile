FROM ubuntu:20.04
LABEL maintainer="Mathew Fleisch <mathew.fleisch@gmail.com>"

ENV ASDF_DATA_DIR /opt/asdf
# Install apt dependencies
RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
    && apt update \
    && apt upgrade -y \
    && apt install -y curl wget apt-utils python3 python3-pip make build-essential openssl lsb-release libssl-dev apt-transport-https ca-certificates iputils-ping git vim zip \
    && apt-get clean \
    && git clone https://github.com/asdf-vm/asdf.git ${ASDF_DATA_DIR} --branch v0.8.0 \
    && echo "export ASDF_DATA_DIR=${ASDF_DATA_DIR}" | tee -a /root/.bashrc \
    && echo ". ${ASDF_DATA_DIR}/asdf.sh" | tee -a /root/.bashrc

# Install asdf dependencies
WORKDIR /root
COPY .tool-versions /root/.
RUN . ${ASDF_DATA_DIR}/asdf.sh  \
    && asdf plugin add awscli \
    && asdf plugin add golang \
    && asdf plugin add helm \
    && asdf plugin add helmfile \
    && asdf plugin add jq \
    && asdf plugin add k9s \
    && asdf plugin add kubectl \
    && asdf plugin add kubectx \
    && asdf plugin add shellcheck \
    && asdf plugin add terraform \
    && asdf plugin add terragrunt \
    && asdf plugin add tflint \
    && asdf plugin add yq \
    && asdf install

CMD ["/bin/bash"]