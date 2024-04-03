ARG BUILD_FROM
FROM $BUILD_FROM

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    jq \
    vim \
    sudo \
    openssh-server \
    locales && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd

# sshd settings
RUN echo 'PermitRootLogin Yes' >> /etc/ssh/sshd_config && \
    echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config

# add no password user
ARG USERNAME
RUN useradd -m -s /usr/bin/bash $USERNAME && \
    passwd -d $USERNAME  && \
    adduser $USERNAME sudo && \
    echo "$USERNAME ALL=NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME

ENV LC_ALL=ja_JP.UTF-8
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/usr/sbin/sshd", "-D", "-e"]
