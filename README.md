# molecule-cicd

**Prerequisits**

Getting started to build your sandbox in the cloud, you should have the following utilities
installed:
  - [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
  - [AWS account](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all) and [associated credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html) that allow you to create resources

To use your IAM credentials to authenticate the Terraform AWS provider, set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables or use `aws configure` сommand.

**Bootstrap**

Clone GitHub repository on your local machine follow the instruction below. Infracture as Code (IaC) approach will do all setup for you.

```bash
git clone https://github.com/pidumenk/molecule-cicd.git
cd molecule-cicd/terraform
terraform init
terraform apply

# You will be prompted for the instance type and name for the private key.
var.instance_type
  Enter a value: t2.large # EC2 instance types (t2.micro,t2.large,etc).

var.key_name
  Enter a value: ec2-key # This key will be used to ssh to your server. Any name is applicable.
```

After terraform has successfully performed an EC2 deployment, you can log in to the server using the key in your working directory that was generated by the configuration. The instance is already in a pre-configured state and contains Ansible and the user under which you will make further changes on the server.

```bash
# IP address or server DNS name is displayed in the AWS console
ssh -i {{var.key_name}} ubuntu@ec2-18-197-130-207.eu-central-1.compute.amazonaws.com
```
Next, we move on to installing the dependencies we need to successfully run our CI/CD.

```bash
# Switch your working directory
cd molecule-cicd

# Run ansible playbook to install Docker, Jenkins, Molecule and all dependencies
ansible-playbook playbooks/os.yaml

# JFYI You can also run each playbook separately
ansible-playbook playbooks/os.yaml -t docker,jenkins
ansible-playbook playbooks/os.yaml -t molecule

# Check the installation
source /opt/molecule-virtualenv/bin/activate
molecule --version
systemctl status docker
systemctl status jenkins
```

Molecule add-hoc commands

```bash
# Create a new role with molecule scenario
molecule init role acme.{{ROLE_NAME}} -d {{DRIVER_NAME}} --verifier-name {{VERIFIER_NAME}}
molecule init role acme.my_new_role -d docker --verifier-name testinfra

# Add molecule scenario to existing ansible role
molecule init scenario -r {{ROLE_NAME}} -d {{DRIVER_NAME}} --verifier-name {{VERIFIER_NAME}}
molecule init scenario -r ansible_molecule_role -d docker --verifier-name testinfra

# Run the full molecule test
molecule test

# Prepare only virtualization env where the role will be applied
molecule create 

# Apply the role into your virtualization env
molecule converge

# Run molecule  unit test 
molecule verify

# Destroy the sandbox
molecule destroy

# Check the current state and configuration
molecule list
```
**CI/CD setup**

For detailed instructions on creating CI/CD for testing Ansible roles in Jenkins and building Allure reports, please, visit my [Medium](https://medium.com/@pidumenk/the-idea-of-testing-ansible-roles-through-molecule-incl-25a63e9b759c) page.