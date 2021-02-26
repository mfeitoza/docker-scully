FROM node:12

RUN apt-get update && apt-get install -y  \
      chromium \
      ca-certificates

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV SCULLY_PUPPETEER_EXECUTABLE_PATH /usr/bin/chromium-browser 