FROM mathewfleisch/tools:v0.1.0
LABEL maintainer="Mathew Fleisch <mathew.fleisch@gmail.com>"

ENV ASDF_DATA_DIR /opt/asdf

USER root
# Install asdf dependencies
WORKDIR /root
COPY .tool-versions ./.tool-versions
COPY pin ./pin
RUN . ${ASDF_DATA_DIR}/asdf.sh  \
    && asdf update \
    && echo "$(while IFS= read -r line; do asdf plugin add $(echo $line | awk '{print $1}'); done < .tool-versions)" \
    && asdf install
    # && while IFS= read -r line; do asdf plugin add $(echo "$line" | awk '{print $1}'); done < .tool-versions \
    # && while IFS= read -r line; do asdf global $(echo "$line" | awk '{print $1}') $(echo "$line" | awk '{print $2}'); done < .tool-versions

CMD /bin/bash -c '. ${ASDF_DATA_DIR}/asdf.sh && /bin/bash'
