# Minecraft Server Setup Tooling
Jakob Conner
CS 312 - Course Project Part 2
Spring 2025

## Background
This is a set of tools to set up a Minecraft server running in a docker container on an Amazon AWS EC2 instance. These tools do not require any manual interfacing with the complex AWS terminal or directly via ssh.

Terraform is used to provision the instance. Certain settings may be tweaked in `./terraform/variables.tf`, but do so at your own risk.

Ansible is then used to set up and launch the server via Docker. By default, [itzg's minecraft-server docker image](https://hub.docker.com/r/itzg/minecraft-server) is used, but you may change your desired image in `./ansible/playbook.yml`. However, as with the Terraform settings, do so at your own risk.
<br/>
![Pipeline Diagram](./doc_assets/Pipeline%20Diagram.png "Pipeline Diagram")
</br>
Once run, your project root directory will contain a file named `private_key.pem`. Save this key, as you'll need it if you wish to make any further adjustments to the server in the future.

## Requirements
- Access to AWS
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) - Tested on version 1.12.2
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) - Tested on version 2.18.5
    - During development, ansible was installed directly via apt. You may use the pip version, but no guarentees are made about compatibility.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - Tested on version 2.27.34
- AWS CLI Credentials
    - The easiest way to set these up is to paste your credentials into ~/.aws/credentials. However, there are other methods - such as `aws configure` - that you are free to use as well.
    - For those using AWS Learner Lab, your credentials may be found under the "AWS Details" button on the top bar of the lab, to the right of the start and end lab buttons.
    - Those with other forms of AWS access will need to locate their own credentials. Please see the appropriate [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-prereqs.html).

This tooling was designed for WSL with Ubuntu 24.04 LTS. Ubuntu 24.04 will also be selected for the EC2 instance hosting the server. You are free to use a different operating system, but no guarentees about compatibility are made and no support will be provided.

## Usage Guide

### Setup
To get started, simply clone the repository to anywhere within your WSL instance. Then, `cd` into the base directory. 

To make sure that you have all required dependencies, run the following commands:

```
terraform -version
ansible --version
aws --version
```

If any of them error, go back and follow the appropriate installation steps [linked above](#requirements).

In addition, to verify that your AWS credentials are appropriately configured, you can run `aws sts get-caller-identity`. If this errors, your credentials are not correct.

## Provisioning Resources via Terraform
First, navigate into the terraform directory with the command `cd terraform`.

Next, run the following commands in sequence to setup Terraform and provision resources.

```
terraform init
terraform apply
```

After running the second command, you will have to respond with `yes`. Do so, then wait for the command to finish. When it does, it will output a public IP address. Take note of this address somewhere, as you'll need it for future steps. You'll also be given an instance ID, but this is for debugging purposes and not needed for standard operation.

## Server Setup via Ansible
Now that you have an EC2 instance and the associated networking infrastructure, it's time to set up the Minecraft server. First, run the following commands to navigate into the Ansible directory.

```
cd ..
cd ansible
```

Next, we need to replace `PUBLIC_IP_GOES_HERE` with the IP from the previous step in the folder `inventory.ini`. Do this with your text editor of choice.

Now we're ready to run our playbook via the following command:
```
ansible-playbook -i inventory.ini playbook.yml
```
It's likely you'll be told that the authenticity of the host can't be established. If this occurs, simply respond with `yes` to continue.

The command will take some time to run. However, once it's finished, your Minecraft server will be ready.

## Connecting to the Server
To connect to the server, simply launch the latest version of Minecraft. Click `Multiplayer`, then `Add Server`. The name can be whatever you want, but for server address you must put the IP from earlier followed by `:25565`. Hit `Done`, then select the server and click `Join Server`. 

# Learning More
Below are the resources that were used to build this pipeline. Reference them if you want to learn more!

- [Terraform Documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build)
- [Ansible Documentation](https://docs.ansible.com/)

In addition, both [Stack Overflow](https://stackoverflow.com/) and LLMs such as [ChatGPT](https://chatgpt.com/) remain great resources if you want to make modifications or something isn't working.