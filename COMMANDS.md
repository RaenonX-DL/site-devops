# Commands

Commands for performing certain actions.

## Start the app using `pm2`

```bash
pm2 start pm2.yml --env=production
```

- `pm2.yml` is the pm2 config file.
- `--env=production` notifies the application to use the production environment.

> Don't use `--watch` because the app caches the file path.
> Use `pm2 restart <APP_NAME>` upon new deployment instead
> (Check [CD](/AZURE-DEVOPS.md#CD) step 13).

## Find processes listening on certain port

```bash
netstat -plnt | grep ':8787'
```

> This finds the processed listening to port 8787.

## Check system calls that used `npm`

```bash
grep "npm" /var/log/syslog
```

> This requires root access.
