FROM ubuntu:20.04 as builder

RUN apt update -y && apt upgrade -y && apt -y install aria2

ARG USERNAME
ARG PASSWORD
ARG OUTFILE=/tmp/ace-install.tar.gz
ARG DOWNLOAD_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/12.0.2.0-ACE-LINUX64-DEVELOPER.tar.gz


RUN if [ -z $USERNAME ]; then aria2c -x 16 -o $OUTFILE ${DOWNLOAD_URL}; else aria2c -x 16 --o $OUTFILE --http-user=$USERNAME --http-passwd=$PASSWORD  ${DOWNLOAD_URL}; fi

RUN mkdir -p /opt/ibm/ace-12

RUN tar -vzxf /tmp/ace-install.tar.gz --wildcards --strip-components 1 --directory /opt/ibm/ace-12

FROM ubuntu:20.04

# Install ACE v12.0.2.0 and accept the license
COPY --from=builder /opt/ibm/ace-12 /opt/ibm/ace-12

RUN apt update -y && apt upgrade -y

# Force reinstall tzdata package to get zoneinfo files
RUN apt install -y python3 vim xvfb libswt-gtk-4-java

# Prevent errors about having no terminal when using apt-get
ENV DEBIAN_FRONTEND noninteractive

RUN /opt/ibm/ace-12/ace make registry global accept license silently \
    && useradd --uid 1001 --create-home --home-dir /home/aceuser --shell /bin/bash -G mqbrkrs aceuser \
    && su - aceuser -c "export LICENSE=accept && . /opt/ibm/ace-12/server/bin/mqsiprofile && mqsicreateworkdir /home/aceuser/ace-server" \
    && echo ". /opt/ibm/ace-12/server/bin/mqsiprofile;export DISPLAY=:99;Xvfb :99 2> /dev/null &" >> /home/aceuser/.bashrc


# aceuser
USER 1001

# Set entrypoint to run the server
ENTRYPOINT ["bash"]
