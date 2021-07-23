# Commands

Commands for performing certain actions.

## Start the app using `pm2`

```bash
pm2 start pm2.yml --env=production --watch
```

- `pm2.yml` is the pm2 config file.
- `--env=production` notifies the application to use the production environment.
- `--watch` watches the file and restarts if any file has changed.

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
