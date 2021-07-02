FROM mathewfleisch/docker-dev-env-base:latest
LABEL maintainer="Mathew Fleisch <mathew.fleisch@gmail.com>"

ENV ASDF_DATA_DIR /opt/asdf

USER root
# Install asdf dependencies
WORKDIR /root
COPY .tool-versions /root/.
COPY scripts /root/scripts
COPY pin /root/.
COPY tests /root/tests
RUN chmod a+x /root/scripts/*.sh \
    && . ${ASDF_DATA_DIR}/asdf.sh  \
    && asdf update \
    && while IFS= read -r line; do dep=$(echo "$line" | sed 's/\ .*//g'); asdf plugin add $dep; done < .tool-versions \
    && asdf install

CMD /bin/bash -c '. ${ASDF_DATA_DIR}/asdf.sh && /bin/bash'
