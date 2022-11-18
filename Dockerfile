FROM debian:bullseye-slim

## Define build arguments.
ARG ROOTHOME='/root/home'
ARG NETWORK='testnet'

## Install dependencies.
RUN apt-get update && apt-get install -y \
  curl git lsof man neovim netcat procps qrencode xxd tmux

## Copy over runtime.
COPY image /
COPY config /config/
COPY home /root/home/

## Add custom profile to bashrc.
RUN PROFILE="$ROOTHOME/.profile" \
  && printf "\n[ -f $PROFILE ] && . $PROFILE\n\n" >> /root/.bashrc

## Uncomment this if you want to wipe all repository lists.
#RUN rm -rf /var/lib/apt/lists/*

## Setup Environment.
ENV PATH="$ROOTHOME/bin:/root/.local/bin:$PATH"
ENV NETWORK="$NETWORK"

WORKDIR /root/home

ENTRYPOINT [ "entrypoint" ]
