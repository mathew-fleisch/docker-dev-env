FROM mathewfleisch/tools:v0.2.14
LABEL maintainer="Mathew Fleisch <mathew.fleisch@gmail.com>"

ENV ASDF_DATA_DIR /opt/asdf

USER root
# Install asdf dependencies
WORKDIR /root
COPY .tool-versions ./.tool-versions
COPY pin ./pin
RUN . ${ASDF_DATA_DIR}/asdf.sh  \
    && cat .tool-versions | awk '{print $1}' | sort | uniq | xargs -I {} asdf plugin add {} || true \
    && asdf install

CMD /bin/bash -c '. ${ASDF_DATA_DIR}/asdf.sh && /bin/bash'
