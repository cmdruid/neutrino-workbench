# Neutrino Workbench

A docker workbench environment, pre-configured for running LND in neutrino mode.

## How to Setup

Before launcing your project in workbench, you will need to setup the environment.

Here is an overview of the project filesystem:

```sh
/config      # Mounted read-only inside the container at /config.
             # Useful for collecting all of our config files in 
             # one place, so we can tweak them between builds.

/home        # Mounted inside the container at /root/home.
             # Scripts placed in 'bin' are added to your PATH 
             # environment. The .init script is loaded at login.

/image       # Copied to the container's root filesystem at '/'.
             # Create your desired filesystem in here, using the 
             # proper paths. (for ex. binaries in /image/usr/bin/')

.env.sample  # Example of .env file. Used for setting variables that
             # are passed into the container during build and runtime.

compose.yml  # Configuration file for the container. You can launch in 
             # detached mode by using: 'docker compose up --build -d'

Dockerfile   # Image build script for the container. Feel free to tweak
             # and configure this file to your liking!

README.md    # You are here!
```

The `home/bin/entrypoint` script is called when the container starts. Make sure to configure this for your application!

**Tips**  

- Use `config` as a central place to store your needed configuration files.
- The `home` folder is reloaded upon login. Feel free to customize your environment frequenlty!
- Use the `home/bin` folder to store your own custom scripts (and call them directly).
- Use the `.init` and `.profile` scripts to customize your own shell environment.
- Feel free to `--build` frequently as you make changes to the filesystem.
- Install new apps by modifying the `apt install` line in your `Dockerfile`.

## How to Use
```sh
## Build the image and start in a container.
docker compose build
docker compose up

## Start the container in detached mode.
docker compose up -d

## You can also do all of this in one line.
docker compose up --build -d

## Log into a currently running container.
docker exec -it <container name> bash

## If you have any issues with your startup script,
## run it from within the container for easy debugging.
docker compose run -it --entrypoint bash <container name>
<~/home#> entrypoint
```

## Resources

**Docker Compose Reference**  
https://docs.docker.com/compose/compose-file

**Docker Builder Reference**  
https://docs.docker.com/engine/reference/builder

**Docker Exec Reference**  
https://docs.docker.com/engine/reference/commandline/exec

**LND Documentation**  
https://github.com/lightningnetwork/lnd/blob/master/docs/INSTALL.md

**LND Docker Documentation**  
https://github.com/lightningnetwork/lnd/blob/master/docs/DOCKER.md

**LND Sample Configuration File**  
https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf
