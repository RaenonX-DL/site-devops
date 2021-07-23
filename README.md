# DL Services DevOps Notes

Notes for DevOps `node.js` web application using VMs 
with `nginx` for reverse-proxy, `newrelic` for system monitoring.

## Documents

### [Initial VM Deployment](/DEPLOY-VM.md)

- Setup new user for production
- Setup NGINX
- Setup New Relic APM

### [Azure DevOps Setup](/AZURE-DEVOPS.md)

- Setup CI/CD

### [Post VM Deployment](/DEPLOY-POST.md)

- Setup continuous delivery
- Allow access publicly

### [Common Commands](/COMMANDS.md)

- Starting the app

### [App Deployment Workflow](/DEPLOY-APP.md)

Check [Azure DevOps Setup](/AZURE-DEVOPS.md) instead if CI/CD service 
is available/deployed on Azure.

-------------

The whole deploying procedure is expect to be similar like the following:

1. [Deploy VM](/DEPLOY-VM.md)
2. [Setup Azure DevOps](/AZURE-DEVOPS.md)
3. [Post VM Deployment](/DEPLOY-POST.md)
