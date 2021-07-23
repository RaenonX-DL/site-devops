# Post VM Deployment

Procedure to perform on VM after all setups are done.

## Setup Continuous Delivery

This must be done after completed [establishing the CI pipeline](/AZURE-DEVOPS#CI.md).

1. Go to VM page.
2. Go to **Settings > Continuous Delivery** at the left panel.
3. Configure as needed.
  - Deployment group should be something like `DL Site Front Deployment Group`

## Configure DNS

Use an unused submodain first to check if the app is public.
- Temporarily add the unused host name as `domain_name` 
  in [`nginx` config](/DEPLOY-VM.md/#Configure-`nginx`)

### Using domain address (example.com)

This is configured during [initial VM deployment](/DEPLOY-VM.md#Configure-IP-DNS).

- Set the domain address as `CNAME` record.
  - `Name` is the subdomain.
  - `Content` is the configured domain address.

For example, if the configured DNS is `example.com` and the domain is `domain.com`,
setting `Name` as `subdomain` and `Content` as `example.com` allows the user on the internet 
to connect to the VM using `subdomain.domain.com`.

### Using static IP (10.0.0.1)

**Use domain address whenever it's possible to increase security.**

- Set the IP address as `A` record.
  - `Name` is the subdomain.
  - `Content` is the IP of the VM.

For example, if the IP of the VM is `10.0.0.1` and the domain is `domain.com`,
setting `Name` as `subdomain` and `Content` as `10.0.0.1` allows the user on the internet 
to connect to the VM using `subdomain.domain.com`.
