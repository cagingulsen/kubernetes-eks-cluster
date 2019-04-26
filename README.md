# Blue Harvest EKS Cluster
[![Build Status](https://travis-ci.org/cagingulsen/kubernetes-eks-cluster.svg?branch=master)](https://travis-ci.org/cagingulsen/kubernetes-eks-cluster)

This repository contains terraform code to provision a fully operational EKS Kubernetes cluster.
## User Guide
### Travis Configuration

- Developer should give access to Travis CI for accessing Github.
- Developer should create an AWS account with Access Key ID and Secret Access Key (by giving only required permissions to the new AWS Account).
- Developer should create Github OAuth Token. Github → Settings → Developer settings → Personal access tokens → Generate Token. Name your token and pick "repo Full control of private repositories" scope.
- Environment variables should be set in Travis CI → Project → Settings → Environment Variables. Here are the needed variables:
    - AWS_ACCESS_KEY_ID
    - AWS_DEFAULT_REGION
    - AWS_SECRET_ACCESS_KEY
    - GITHUB_OAUTH_TOKEN
- You can check your builds on the website [https://travis-ci.org/GITHUBACCOUNTNAME/kubernetes-eks-cluster](https://travis-ci.org/cagingulsen/kubernetes-eks-cluster)

#### Triggers

- Build Stage: Automated, it gets triggered from Github commits.
- Deploy Stage: Manual, you need to go to project page in Travis website, then click "More options", then click "Trigger build". Fill CUSTOM CONFIG part with the following:

        env:
          global:
            - TERRAFORM_VERSION=0.11.11
            - SHOULD_DEPLOY=true
            - SHOULD_DESTROY=false

    and click "Trigger custom build". Then you can check your deployment from logs.

    If deployment is successful, you can download artifacts from [https://github.com/GITHUBACCOUNTNAME/kubernetes-eks-cluster/releases](https://github.com/cagingulsen/kubernetes-eks-cluster/releases)

    ***WARNING***:

    If the repository is public, exposing artifacts (when Cluster is online) is not secure. 

- Destroy Stage: Manual, like Deploy Stage, you need to go to project page in Travis website, then click "More options", then click "Trigger build". Fill CUSTOM CONFIG part with the following:

        env:
          global:
            - TERRAFORM_VERSION=0.11.11
            - SHOULD_DEPLOY=false
            - SHOULD_DESTROY=true

    and click "Trigger custom build". Then you can check your destroy from logs. If something unexpected happens, trigger the stage again or go to AWS Console and destroy leftovers manually.

#### Issues

1) For Destroy Stage, instead of:

```
- terraform destroy -force
```

I had to use:

```
- terraform apply -input=false -auto-approve=true
- terraform plan
- terraform destroy -force
```

Open to suggestions.

### Kubernetes Guide

Inside the configuration.zip file, we will find a file named kubeconfig_$CLUSTER_NAME and another file called $CLUSTER_NAME.ovpn

You must set your KUBECONFIG environment var pointing to the kubeconfig file, and open the ovpn file with an Open VPN client.

```bash 
$ export KUBECONFIG=<PATH>/kubeconfig_$CLUSTER_NAME
```

To actually use your kubectl command line tool, you will need the aws authentication command line tool in your system:

```bash 
$ curl -L https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_darwin_amd64 >> /usr/local/bin/aws-iam-authenticator
$ chmod 755 /usr/local/bin/aws-iam-authenticator
```

Plus, your AWS environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION) must be defined, and they must belong to a user added to the aws-auth config map or to the user that has run the terraform command.

At this point, you must be able to run the following command and see all the pods running in your cluster:

```bash 
$ kubectl get pods --all-namespaces
```

With the OpenVPN properly connected, you also must be able to reach the following endpoints:

* https://dashboard.<CLUSTER_NAME>.blueharvest.io
* https://kibana.eks.<CLUSTER_NAME>.blueharvest.io/
* https://grafana.<CLUSTER_NAME>.blueharvest.io
* https://cerebro.<CLUSTER_NAME>.blueharvest.io
* https://prometheus.<CLUSTER_NAME>.blueharvest.io
* https://alertmanager.<CLUSTER_NAME>.blueharvest.io
* https://pushgateway.<CLUSTER_NAME>.blueharvest.io
* https://servicegraph.<CLUSTER_NAME>.blueharvest.io
* https://tracing.<CLUSTER_NAME>.blueharvest.io
* https://kiali.<CLUSTER_NAME>.blueharvest.io
   

## Architecture

* EKS
* EC2
* Terraform
* Helm
* Istio
* Prometheus
* Grafana
* EFK
* Cluster Autoscaler
* Cert Manager
* External DNS
* NGINX Controller