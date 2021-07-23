# App Deployment

**It's strongly recommended to setup CI/CD on a separate machine,
because doing so on the production machine is likely to consume all the resources,
impacting the production performance.**

For Azure deployment pipeline setup, check [AZURE-DEVOPS.md CD section](/AZURE-DEVOPS#CD).

--------------

Check [the deployment shell script](/samples/deploy.sh) for most of the logic.

## Steps

This just provide a basic idea of the app deployment workflow.

1. Download/Clone the repo
  1. Build if not yet done
2. Run the [app starting command](/COMMANDS.md#Start-the-app-using-`pm2`)
  - If `pm2` is not a command, run `npm install -g pm2` first.
