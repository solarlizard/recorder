FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y xvfb curl wget gnupg2 ffmpeg apt-utils pulseaudio socat alsa-utils gcc g++ make x264

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g npm yarn

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update
RUN apt-get -y install google-chrome-stable

RUN adduser root pulse-access

ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/dbus/system_bus_socket"

RUN mkdir /var/run/dbus
RUN dbus-uuidgen > /etc/machine-id
RUN dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

RUN rm -rf /var/run/pulse /var/lib/pulse /root/.config/pulse

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /app
COPY package.json /app
COPY yarn.lock /app

RUN yarn

COPY tsconfig.json /app
COPY index.ts /app

CMD "/entrypoint.sh"
