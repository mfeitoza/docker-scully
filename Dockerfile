FROM amazonlinux:2
MAINTAINER Amazon AWS

# Framework Versions
ENV VERSION_NODE_8=8.12.0
ENV VERSION_NODE_10=10.16.0
ENV VERSION_NODE_12=12
ENV VERSION_NODE_DEFAULT=$VERSION_NODE_12
ENV VERSION_BUNDLER=2.0.1
ENV VERSION_YARN=1.16.0
ENV VERSION_AMPLIFY=1.12.0

# UTF-8 Environment
ENV LANGUAGE en_US:en
ENV LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Install OS packages
RUN touch ~/.bashrc
RUN yum -y update && \
    yum -y install \
        alsa-lib-devel \
        autoconf \
        automake \
        bzip2 \
        bison \
        bzr \
        ca-certificates \
        cmake \
        chromium \
        expect \
        fontconfig \
        freetype \
        freetype-dev \
        harfbuzz \
        git \
        gcc-c++ \
        GConf2-devel \
        gtk2-devel \
        gtk3-devel \
        libnotify-devel \
        libpng \
        libpng-devel \
        libffi-devel \
        libtool \
        libX11 \
        libXext \
        libxml2 \
        libxml2-devel \
        libXScrnSaver \
        libxslt \
        libxslt-devel \
        libyaml \
        libyaml-devel \
        nss \
        nss-devel \
        openssl-devel \
        openssh-clients \
        patch \
        procps \
        python3 \
        python3-devel \
        readline-devel \
        sqlite-devel \
        tar \
        tree \
        unzip \
        wget \
        which \
        xorg-x11-server-Xvfb \
        zip \
        zlib \
        zlib-devel \
    yum clean all && \
    rm -rf /var/cache/yum

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV SCULLY_PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium-browser

## Install Node 8 & 10 & 12
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN curl -o- -L https://yarnpkg.com/install.sh > /usr/local/bin/yarn-install.sh
RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
    nvm install $VERSION_NODE_8 && nvm use $VERSION_NODE_8 && \
	nvm install $VERSION_NODE_10 && nvm use $VERSION_NODE_10 && \
	npm install -g sm grunt-cli bower vuepress gatsby-cli && \
    bash /usr/local/bin/yarn-install.sh --version $VERSION_YARN && \
	nvm install $VERSION_NODE_12 && nvm use $VERSION_NODE_12 && \
	npm install -g sm grunt-cli bower vuepress gatsby-cli && \
    bash /usr/local/bin/yarn-install.sh --version $VERSION_YARN && \
	nvm alias default node && nvm cache clear"

## Install awscli
RUN /bin/bash -c "pip3 install awscli && rm -rf /var/cache/apk/*"

## Install SAM CLI
RUN /bin/bash -c "pip3 install aws-sam-cli"

## Installing Cypress
RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
    nvm use ${VERSION_NODE_DEFAULT} && \
    npm install -g --unsafe-perm=true --allow-root cypress"

## Install AWS Amplify CLI for VERSION_NODE_DEFAULT and VERSION_NODE_10
RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_DEFAULT} && \
    npm config set user 0 && npm config set unsafe-perm true && \
	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"
RUN /bin/bash -c ". ~/.nvm/nvm.sh && nvm use ${VERSION_NODE_10} && \
    npm config set user 0 && npm config set unsafe-perm true && \
	npm install -g @aws-amplify/cli@${VERSION_AMPLIFY}"

## Environment Setup
RUN echo export PATH="\
/root/.yarn/bin:\
/root/.config/yarn/global/node_modules/.bin:\
/root/.nvm/versions/node/${VERSION_NODE_DEFAULT}/bin:\
$(python3 -m site --user-base)/bin:\
$PATH" >> ~/.bashrc && \
    echo "nvm use ${VERSION_NODE_DEFAULT} 1> /dev/null" >> ~/.bashrc

ENTRYPOINT [ "bash", "-c" ]
© 2021 GitHub, Inc.
