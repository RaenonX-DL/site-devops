# Azure DevOps Setup

Procedure to setup CI/CD.

## Pre

1. Create an Azure DevOps organization.
2. Create a project.
3. Project Settings to verify the following configs:
  - General Overview > `Process` is `Agile`.
  - Pipelines > Settings `Disable anonymous access to badges` is NOT checked.

## CI

1. Create a pipeline file to store at `.azure/pipeline.yml` and commit it to `azure` branch.
2. Configure pipeline content.
3. Setup required pipeline-level environment variables.
  - `CODACY_PROJECT_TOKEN`: Obtained from Codacy coverage setting. For analyzing coverage.
4. Validate YAML.
5. Commit pipeline file.
6. Edit pipeline > Triggers > YAML > Get sources.
7. Verify the settings:
  - Sourced from GitHub.
  - Using correct repo.
  - Default branch is `main`
  - **NEVER** tag sources.
  - `Report build status` should be **CHECKED**.
  - `Checkout submodules` should be **CHECKED** with nested recursion.
  - `Shallow fetch` set to `1`.
8. Name the pipeline as `<APP_NAME> (Build)`. For example, `dragalia-site-front (Build)`.
9. Test run. Should these artifacts available:
  - Built source
  - Code coverage report
10. Verify Test & Coverage are reported.

## CD

1. [Setup Continuous Delivery](/DEPLOY-POST.md#Setup-Continuous-Delivery) on Azure VM.
2. Edit the auto-created pipeline.
3. Rename to `<APP_NAME> (Deploy)`. For example, `dragalia-site-front (Deploy)`.
4. Artifact to have the following settings:
  - `Default Version`: Latest
  - `Source Alias`: <APP_NAME>-source. For example, `dragalia-site-front-source`.
5. Artifact trigger to have the following setting:
  - CD trigger `Enabled`
  - Build branch filter to `include main` only
  - PR trigger `Disabled`
6. Pre-deployment conditions to check `After release`
7. Post-deployment conditions to check `Auto-redeploy trigger` with the following:
  - `Event`: Deployment to this stage fails
  - `Action`: Redeploy the last successful deployment
8. Process to have the following settings:
  - The only stage should be named as `deploy`
  - Job group display name to be `Deploy`
  - `Deployment Group` to pick the one configured in step 1
  - `Artifact download` to ensure only the build one is downloaded, no coverage report
9. Add 3 jobs:
  - Extract files
  - Copy files
  - Bash script
10. Extract job to have the following settings:
  - `Display Name`: Extract Build Artifacts
  - `Archive Pattern`: $(System.ArtifactsDirectory)/<APP_NAME>-source/<ARTIFACT>/<TAR_FILE>
    - `<APP_NAME>-source` configured in step 4.
    - `<ARTIFACT>` is the artifact name to be downloaded in step 8 artifact download.
    - `<TAR_FILE>` should be the file containing the built source. 
      This should be configured in [CI](#CI) step 2.
  - `Destination Folder`: /home/deploy/<APP_NAME>
  - **Check** clean destination before extracting.
11. Copy job to have the following settings:
  - `Display Name`: Setup Environment Variables
  - `Source Folder`: /home/deploy
  - `Contents`: .env
  - `Target Folder`: /home/deploy/<APP_NAME>
    - Same as extract destination.
  - **UNCHECK** clean target folder because checking this is the opposite step 10.
12. Bash script job to have the following settings:
  - `Display Name`: Reload pm2
  - `Type`: inline
  - `Script`: `pm2 reload <APP_NAME>`
  - `Environment Variables`:
    - `HOME`: `/home/deploy`
      - Related doc: https://stackoverflow.com/q/32178443/11571888
13. Test deploy. `/home/deploy/<APP_NAME>` should have the app ready to be deployed.
14. Edit the pipeline, go to "Options" tab.
15. Change Release name format to `Release-$(rev:r) ($(Build.BuildNumber))`.
16. Go to Integrations section.
  - Check "Report deployment status to the repository host"
  - Check "Enable the deployment status badge"
