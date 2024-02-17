# KUBERNETES ON EKS

This project contains a Flask app that has been containerized and pushed to Dockerhub. The goal is to deploy this app in an AWS EKS cluster.

## Architecture

![architecture](./public/images/architecture.png)

## Prerequisites

Before proceeding, ensure you have the following prerequisites installed:

- [Docker hub account](https://hub.docker.com/)
- [Python](https://docs.python.org/3/using/index.html)
- [Pip](https://pip.pypa.io/en/stable/installation/)
- [Terraform](https://developer.hashicorp.com/terraform/install) (version 0.15.0)

## Installing dependencies

To install the dependencies, please use: `pip3 install -r requirements.txt`

## How to provision resources

```sh
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

## How to destroy provisioned resources

```sh
$ terraform destroy --auto-approve
```

## URL to public GitHub repo

https://github.com/LaraTunc/wcd-7-kubernetes

## Dockerhub Image

https://hub.docker.com/repository/docker/laratunc/simple_flask_app/general

## Docs

- [Building multi platform images](https://docs.docker.com/build/building/multi-platform/)
- `docker buildx build --platform linux/amd64,linux/arm64 -t <username>/<image> --push .`
