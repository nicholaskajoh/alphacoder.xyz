+++
author = "Nicholas Kajoh"
date = 2018-12-02T13:13:00.000Z
draft = false
slug = "git-push-to-an-aws-ec2-remote-using-a-pem-file"
tags = ["Source Control", "Cloud Computing"]
title = "How to Git push to an AWS EC2 remote using a PEM file"

+++


AWS provides you with a _.pem_ file when creating an EC2 instance. You can use this file to generate SSH keys for accessing your server without the need for the PEM, as well as push to a remote Git repository on the server. Here’s how…

### 1\. Copy private key in PEM to .ssh folder

    $ cp /path/to/my-aws-ec2-instance.pem ~/.ssh/id_rsa_ec2
    

### 2\. Generate and save public key

    $ ssh-keygen -y -f /path/to/my-aws-ec2-instance.pem > ~/.ssh/id_rsa_ec2.pub
    

### 3\. Add private key to ssh-agent

Start ssh-agent

    $ eval "$(ssh-agent -s)"
    

Then add your key to the agent

    $ ssh-add ~/.ssh/id_rsa_ec2
    

_At this point, you should be able to access your instance without the PEM file. Instead of:_

    $ ssh -i my-aws-ec2-instance.pem ec2-user@ec2-ip.compute-x.amazonaws.com
    

_Use:_

    $ ssh ec2-user@ec2-ip.compute-x.amazonaws.com
    

### 4\. Add remote and push

Change directory to your local Git repository and add the remote URL of your server

    $ git remote add ec2server ec2-user@ec2-ip.compute-1.amazonaws.com:/home/ec2-user/repo.git
    

Now push…

    $ git push ec2server