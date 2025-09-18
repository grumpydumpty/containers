FROM photon:5.0

# set argument defaults
ARG OS_ARCH="amd64"
ARG OS_ARCH2="x86_64"
ARG USER=vlabs
ARG GROUP=users

# set locale
ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
ENV TERM=linux

# update repositories, install packages, and then clean up
RUN tdnf update -y && \
    tdnf install -y glibc-i18n && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale-gen.conf && \
    locale-gen.sh && \
    # grab what we can via standard packages
    tdnf install -y \
        bash \
        bindutils \
        ca-certificates \
        coreutils \
        curl \
        diffutils \
        findutils \
        gawk \
        git \
        gnupg \
        htop \
        jq \
        less \
        make \
        mc \
        ncurses \
        openssh \
        shadow \
        tar \
        tree \
        tmux \
        unzip \
        vim && \
    # add user/group
    # groupadd -g ${GROUP_ID} ${GROUP} && \
    # useradd -u ${USER_ID} -g ${GROUP} -m ${USER} && \
    useradd -g ${GROUP} -m ${USER} && \
    # set ownership on home dir
    chown -R ${USER}:${GROUP} /home/${USER} && \
    # set permissions
    chmod 0700 /home/${USER} && \
    # create /workspace
    mkdir -p /workspace && \
    # give new user ownership of /workspace
    chown -R ${USER}:${GROUP} /workspace && \
    # set permissions
    # chmod 0700 /workspace && \
    # set git config
    git config --system --add init.defaultBranch "main" && \
    git config --system --add safe.directory "/workspace" && \
    # clean up
    tdnf erase -y shadow && \
    tdnf clean all && \
    # harden and remove unnecessary packages
    chown -R root:root /usr/local/bin/ && \
    chown root:root /var/log && \
    chmod 0640 /var/log && \
    chown root:root /usr/lib/ && \
    chmod 755 /usr/lib/

# set user
USER ${USER}:${GROUP}

# set working directory
WORKDIR /workspace

# set default command to bash, do not set an entry point
# CMD [ "bash", "-l" ]

#############################################################################
# vim: ft=unix sync=dockerfile ts=4 sw=4 et tw=78:
