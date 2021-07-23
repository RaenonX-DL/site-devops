# Initial VM Deployment

Initial VM deployment procedure.

## Create VM

- Enable monitoring
- Use private SSH credentials as auth
  - This credential should be passphrase-encrypted, and only used for accessing the VM.
- Name it properly

### Configure VM firewall

Ensure the following rules are applied.

#### Inbound

- SSH (22/TCP)
- DNS TCP (53/TCP)
- DNS UDP (53/UDP)
- HTTP (80/TCP)
- HTTPS (443/TCP)

#### Outbound

- ICMP
- All TCP (*/TCP)
- All UDP (*/UDP)

### Configure IP DNS

These steps are performed on Azure VMs.

1. Go to the **Public IP Address** associated with the VM.
2. Go to **Setting > Configuration** at the left panel.
3. Add **DNS name label**.

### Rename Network Interface

1. Install Azure PowerShell if not yet installed.
  - https://github.com/Azure/azure-powershell/releases
2. Execute `scripts/az-nic-rename.ps1`

## Setup VM

1. `sudo apt update`
2. `sudo apt upgrade -y`
3. `curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -`
4. `sudo apt install nodejs nginx net-tools -y`
5. `sudo npm install -g npm pm2`
6. `sudo reboot`
7. (wait for reboot to complete)
8. `ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts`
  - This step is only needed if deploy via SSH.
9. `sudo adduser --disabled-password deploy`
10. `sudo rsync --archive --chown=deploy:deploy ~/.ssh /home/deploy`

## Setup deployment workflow on VM (Situational)

This assumes that `deploy` user uses deploy key and `deploy.sh` for deployment.

For services like Azure, **using platforms like pipeline to build the application is strongly preferred**,
as building on VM is likely to consume all resources, impacting the overall servicing quality.

### On VM login as `deploy`

1. `ssh-keygen -t ed25519 -C "raenonx0710@gmail.com"`
2. `cat .ssh/id_ed25519.pub >> .ssh/authorized_keys`
3. Setup `~/deploy.sh`
  - Check `samples/deploy.sh`
4. `chmod +x deploy.sh`

### Github Actions to set secrets 

- `SSH_HOST`: IP of the VM
- `SSH_PRIVATE_KEY`: Login as `deploy` then `cat .ssh/id_ed25519`
- `SSH_USERNAME`: `deploy`

### Github set deploy keys

- Obtained by `cat .ssh/id_ed25519.pub` as `deploy`
  - Public key generated in step 3
- Located in **Repo Setting > Deploy Keys**

### Setup GitHub workflow

1. Setup env vars for build (use `.env` & store at `~`)
  - Add `NODE_ENV=production`
2. Edit github workflow file
  - Check `samples/workflow.yml`

## Configure `nginx`

1. Check [`samples/nginx/app.conf`](/samples/nginx/app.conf)
  - Change `server_name` to domain with subdomain (`dl.raenonx.cc`)
2. Store at `/etc/nginx/conf.d/<ANY_NAME>.conf`
3. Copy [`samples/nginx/status.conf`](/samples/nginx/status.conf)
4. Store at `/etc/nginx/conf.d/status.conf`
5. `sudo systemctl restart nginx`

## Setup New Relic One

1. Head to https://one.newrelic.com/.
2. Click on "Add more data" at the top right.
3. Click on "Guided install".
4. Follow instructions.
  - Better to run the `curl` command with `sudo`
5. Verify the data is streaming to New Relic.

### During installation

- NGINX status URL: `http://localhost:888/nginx_status`

### After installation

#### Setup log tailing

1. `nano /etc/newrelic-infra/logging.d/logging.yml`
2. Track normal output log
  - `name`: '<APP_NAME> (Out)'
  - `file`: /home/deploy/.pm2/logs/<APP_NAME>-out-\*.log
3. Track error output log
  - `name`: '<APP_NAME> (Error)'
  - `file`: /home/deploy/.pm2/logs/<APP_NAME>-error-\*.log
4. Track `pm2` log
  - `name`: '<APP_NAME> (pm2)'
  - `file`: /home/deploy/.pm2/pm2.log

## Configure `pm2` log rotate

This uses the log rotating module of `pm2`.

1. Login as `deploy`
2. `pm2 install pm2-logrotate`
3. `pm2 set pm2-logrotate:compress true`
4. `pm2 set pm2-logrotate:workerInterval 60`

Official config doc: https://github.com/keymetrics/pm2-logrotate#configure

## Import `.env` files

- Store at `/home/deploy/.env`

## Setup auto-start on reboot

1. After [deployment](/AZURE-DEVOPS.md#CD), start the application once.
  - Use the [app starting command](/COMMANDS.md#Start-the-app-using-`pm2`).
2. Verify if the application is running by `pm2 status`
3. Check if there are any errors using `pm2 logs`.
4. `pm2 save`
5. `pm2 startup` and follow the instruction.
6. `sudo reboot`
7. (wait until reboot completed)
8. `pm2 status` to verify the app is running.
  - Check if watching is enabled.
