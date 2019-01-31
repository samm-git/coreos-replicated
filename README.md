# Replicated on the CoreOS Linux

## How it works

Packer is used to build CoreOS image with replicated pre-downloaded. Also it downlads **arigapped** installation of the PTFE using provided license and password.

Packer will do following actions:

1. Installing replicated systemd units (based on official one)
1. Installing relpilcated CLI tools to the `/opt/bin`
1. Generating random token to be used with replicated
1. Downloading Airgap package of the Terraform enterprise edition and putting
it to the `/var/lib/install-ptfe` folder

## How to use

1. Build packer image
2. Run AMI based on this image with userdata to create  valid `/etc/replicated.conf` and friends
(see `/etc/replicated.conf.sample`). After first run AMI will start replicated and install airagapped package.

## Variables to set

- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` - AWS permissions
- `AWS_VPC_ID` - VPC ID
- `AWS_SUBNET_ID` - subnet ID
- `AWS_SECURITY_GROUP_ID` - Security Group ID
- `PTFE_REPLICATED_PWD` - password to get Airgap replicated installations
- `PTFE_LICENSE_ID` - PTFE license ID
