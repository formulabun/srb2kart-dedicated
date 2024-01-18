# Easy srb2kart dedicated server

### Dedicated srb2kart <u>and http source</u> with docker compose.

This project is a docker compose setup to make it as easy as possible to host a srb2kart dedicated server on a linux server. Follow the steps below to set everything up. Not *everything* will be explained to you, as every system is different. Google is your friend.

## 0 Prerequisites

You first need a linux server with a public IP address to host the server on.

*A windows machine probably works though WSL or just docker desktop, but this guide is focuses on a dedicated linux server.*

See [Getting a server](./docs/getting-a-server.md) for more info. Note down you public IP, or domain name if you have one.

For the rest of this guide you need to open a shell to your server. This is most likely through [ssh](https://www.openssh.com/) directly or though an ssh client like [putty](https://putty.org/).

On the server, install [Git ](https://git-scm.com/downloads)(one of the first three links), [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) (the plugin) using their respective guides.

After installing, run:
```sh
docker version ; docker compose version
```
This guide should work with docker version `24.*` and docker compose version `2.*`.

## 1 Cloning the repository

Clone this repository using in the folder of your choice. Then enter this directory to run the next steps in.

```sh
git clone https://github.com/formulabun/srb2kart-dedicated.git && cd srb2kart-dedicated
```

## 2 Configuring

Edit `srb2kart.env` using an editor like `nano` or `vim`. In there, edit the line

```
PUBLIC_IP=
```

by adding the public ip of your server after the equal sign. For your ease you can copy/rename/link this file to `.env`, but it will be hidden then.

## 3 Customizing

Edit the `configs/kartserv.cfg` file to customize the settings of your kart server. Definitely change the first 4 parameters. The rest are sensible defaults.

To find out more about a particular setting, open a kart console on your pc, and type

```
<cvar> ; help <cvar>
```

after replacing `<cvar>` with one of the settings.

## 4 installing files

First run the following command to know if you have installed everything properly and to get some information.

```bash
docker compose --env-file srb2kart.env run add_file -h
```

If that works, you can first copy you srb2kart addons to the `files/` directory (including `bonuschars.kart` if desired). Copying files can be done with [scp](https://man.openbsd.org/scp.1) or [winscp](https://winscp.net/eng/index.php). Important to note that the files must be immediately in the `files/` directory. Do not create any folders in here.

Now that the files are available it is time to get them ready for the kart server. Do this by running:

```bash
docker compose --env-file srb2kart.env run add_file -map ...files -char ...files -mod ...files -custom num ...files
```

For example:

```bash
docker compose --env-file srb2kart.env run add_file -map KR_TougeOriginal_V1.pk3 KR_NicosSmileZone_v1.2.pk3 -char bonusfiles.kart -mod KL_HORNMOD-CE_V1.pk3 KL_AdvanceTricks-v1.pk3  -custom 00 KL_HOSTMOD_V16.pk3
```

This command can be run multiple times. Check the result with

```bash
docker compose --env-file srb2kart.env run add_file -ls
```

and remove files with

```bash
docker compose --env-file srb2kart.env run add_file -rm KR_NicosSmileZone_v1.2.pk3
```

## 5 Start the server

Starting the server is as simple as:

```bash
docker compose --env-file srb2kart.env up -d srb2kart http_source
```

This will spin up the dedicated srb2kart server and http file server on ports 5029/udp and 5080/tcp respectively. Make sure to open these ports in your firewall / port forward these on your router.

## 6 Extra commands

### Check the status

```bash
docker compose --env-file srb2kart.env ps
```

### Get the logs

```bash
docker compose --env-file srb2kart.env logs srb2kart
```

### Open a kart shell

```bash
docker attach srb2kart
```

Exit the shell by inputting `ctrl-p ctrl-q`. Typing exit or `ctrl-c` will stop the server. But don't worry, it will restart automatically!

### Restart the server

```bash
docker compose --env-file srb2kart.env restart srb2kart
```

Do this after changing the loaded addons. This command can be put in cron by first running `crontab -e`. It will open an editor where you can add the following line:

```
00 3    * * * docker compose -f /path/to/docker-compose.yml --env-file /path/to/srb2kart.env restart
```

It will restart the server every night at 3am.

### See resource usage

```bash
docker stats srb2kart
```

### Debugging issues

see [debugging](./docs/debugging.md).
