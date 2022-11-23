# Neutrino Workbench

A docker workbench environment, pre-configured for running LND in neutrino mode.

## Overview

Here is an overview of the project filesystem:

```sh
## Project Directory

/build       # Contains a build script, plus dockerfiles for
             # downloading, compiling and building binaries.
             # Compressed binaries are saved in 'out' path.

/config      # Mounted as read-only at /config.
             # Useful for collecting our config files in 
             # one place, so we can tweak them between builds.

/home        # Mounted as read-write at /root/home.
             # Scripts placed in 'bin' are added to your PATH 
             # environment. The .bashrc script is loaded at login.

/image       # Copied to root filesystem '/' at build time.
             # Create your desired filesystem in here, using the 
             # proper paths. (for ex. binaries in /image/usr/bin/')

.env.sample  # Example of .env file. Used for setting variables that
             # are passed into the build and runtime environments.

compose.yml  # Container configuration file. Launch your container in 
             # detached mode by using: 'docker compose up --build -d'

Dockerfile   # Main build file for the docker container. Feel free to 
             # configure this file to your liking!

README.md    # You are here!
```

## How to Setup

Before launcing your project in workbench, you may need to setup the environment.

### /image

The `image` directory defines your container's default filesystem, and is where your main binaries will be stored. The included `lnd` binaries should work, however if you need to replace them, you can find other platform binaries [available here](https://github.com/lightningnetwork/lnd/releases/tag/v0.15.4-beta). Make sure to unpack and store your binaries in `image/usr/bin` or `image/usr/local/bin` so they can be called from the command-line. For more information on how to build LND from source, see their [github page](https://github.com/lightningnetwork/lnd).

### /config

The `config` folder contains configuration files for services running within the container. The default configuration should be fine, however you may wish to adjust some settings (port numbers for example).

### /home

The `home` folder contains the main `entrypoint` and `start` scripts used to start the container. Feel free to tweak these scripts for your own needs!

### Configuring your Container

The `env.sample` file contains additional configurations that you may wish to change for your project. Copy and rename this file to `.env`, then cutomize it to your needs. The file will take effect automatically on startup.

The `compose.yml` and `Dockerfile` are used to configure and setup the container. The default configurations should be fine, however you may wish to change some things. Please see the resource links below for more information on how to customize these files.

**Tips**  

- The `Dockerfile` specifies what packages are installed by default. Modify the `apt install` line to add more packages to your container.
- The `home` folder is reloaded upon login, so you can make changes to your environment frequenlty!
- Use the `home/bin` folder to store your own custom scripts (and call them directly).
- Use the `.init` and `.profile` scripts to customize your own shell environment.
- Feel free to `--build` frequently as you make changes to the filesystem.

## How to Use
```sh
## Build the image and start in a container.
docker compose up --build

## Start the container in detached mode.
docker compose up -d

## You can also do all of this in one line.
docker compose up --build -d

## Log into a currently running container.
docker exec -it <container name> bash

## New LND nodes require that you create a wallet.
docker exec -it <container name> lncli create

## Once created, make sure to include your wallet 
## passphrase in the local .env file. This will 
## setup your wallet to auto-unlock on startup.
</.env> WALLET_PW=yourpassphrasehere

## If you have any issues with starting your container,
## log into the container's shell, then start the script.
docker compose run -it --entrypoint bash <container name>
<~/home> entrypoint
```

## REST API

LND has a built in REST API available on port 8080 by default. You can make GET requests using the following headers. Use the `macaroon` command inside your container to print your admin macaroon as a hex-encoded string.

```js
// Example request:
endpoint: 'https://hostname:8080/v1/getinfo'
header: {
  'Grpc-Metadata-Macaroon': '<hex-encoded string of macaroon>',
  'Content-Type': 'application/json'
}
```

## Tor Integration

Setting `TOR_ENABLED=1` in your `.env` file will enable Tor integration. This will configure your node's REST interface to connect over tor, and `lndconnect` command to use your relay's onion address.

### Ngrok Integration

Setting `NGROK_ENABLED=1` in your `.env` file will enable Ngrok integration. This will configure your REST interface to connect over Ngrok, and `lndconnect` command to use the encrypted Ngrok tunnel. You will have to sign up [here](https://ngrok.com) in order to receive an `NGROK_TOKEN` and use their service.

### Zeus Wallet

[Zeus Wallet](https://github.com/ZeusLN/zeus) is a bitcoin / lightning wallet that connect directly to your lightning node. Zeus is compatible with using lndconnect QR codes to connect to your node, which you can generate via running the `lndconnect` command within your container's shell.

## Resources

**LND Documentation**  
https://github.com/lightningnetwork/lnd/blob/master/docs/INSTALL.md

**LND Docker Documentation**  
https://github.com/lightningnetwork/lnd/blob/master/docs/DOCKER.md

**LND Sample Configuration File**  
https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf

**Bolt Payment Specification**  
https://github.com/lightning/bolts

**Docker Compose Reference**  
https://docs.docker.com/compose/compose-file

**Docker Builder Reference**  
https://docs.docker.com/engine/reference/builder

**Docker Exec Reference**  
https://docs.docker.com/engine/reference/commandline/exec
