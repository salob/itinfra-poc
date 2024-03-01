## Introduction

This folder contains the terraform source code required to provision the infrastructure required for a web app.
It provisions a simple architecture to satisfy a POC but could easily be extended.
It comprises of the following main components:

- VPC in us-east-1 region
- 2 Subnets (1 public, 1 private) hosted in us-east-1a and us-east-1b availability zones respectively
- An internet gateway (IGW)
- A NAT gateway to provide internet access to the private subnet resources
- An EC2 client vpn endpoint (CVPN-endpoint) to provide ssh access to the ec2 instances
- 2 EC2 instances, 1 in the public subnet and 1 in the private subnet
- 2 security groups (1 for EC2 instances and 1 for EC2 CVPN-endpoint) with ingress (inbound) and egress (outbound) rules to specify allowed traffic
- 2 route tables (1 for public subnet to route to IGW, 1 for private subnet to route to NAT gateway)

## Implemented Features

- A Client VPN endpoint to restrict and control access to our VPN.
- SSH through VPN to private IP addresses only
- Private subnet for additional security along with NAT gateway to allow access out from private subnet to the internet
- Support for Terraform workspaces to separate dev, staging and production environments in a single AWS account

## Instructions

### Prerequisites

### VPN Client endpoint

The Client VPN endpoint uses cert based authentication. You will need to generate TLS certs and will also require a vpn client to connect.
The OpenVPN client is available for all major operating systems and is easy to use. The OpenVPN project also provide an easy-rsa utility
for creating a certificate authority with signed certs. Below are the steps to get set up quickly and easily. This project is also referenced
on the [AWS docs](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-getting-started.html) for creating a client VPN endpoint

1. Download the relevant openvpn client for your OS: https://openvpn.net/client/
2. Clone the easy-rsa repo `git@github.com:OpenVPN/easy-rsa.git`
3. Navigate to easy-rsa/easyrsa3 folder and run below commands

```
# Initialise new pki environment
./easyrsa init-pki
# Build a new ca authority
./easyrsa build-ca # follow prompts
# Generate server cert and key
./easyrsa build-server-full server nopass
# Generate client cert and key
./easyrsa build-client-full client1.domain.tld nopass
```

4. Copy the following generated certs and keys to the terraform/certs folder in this repo

```
pki/ca.crt
pki/issued/server.crt
pki/private/server.key
pki/issued/client1.domain.tld.crt
pki/private/client1.domain.tld.key
```

### Terraform

Terraform will need to be installed on the machine where you will run the below steps. Most popular package managers are also supported. For more information follow steps here: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

#### Teffaform steps

1. Navigate to terraform directory
`cd terraform`

2. Initialise current directory for terraform use
`terraform init`

3. Create the workspaces for the 3 environments
```
terraform workspace new dev
terraform workspace new staging
terraform workspace new production
```

4. Swith to workspace of choice e.g. dev

```
terraform workspace select dev
```

5. Create terraform plan to preview changes

```
terraform plan
```

6. Execute actions in plan (without prompt)

```
terraform apply -auto-approve
```

7. Destroy all resources in the plan

```
terraform destroy
```