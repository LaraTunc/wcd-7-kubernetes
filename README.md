# KUBERNETES ON EKS

This project contains a Flask app that has been containerized and pushed to Dockerhub. The goal is to deploy this app in an AWS EKS cluster.

## Architecture

![architecture](./public/images/architecture.png)

## Prerequisites

Before proceeding, ensure you have the following prerequisites installed:

- [Docker hub account](https://hub.docker.com/)
- [Python](https://docs.python.org/3/using/index.html)
- [Pip](https://pip.pypa.io/en/stable/installation/)

## Installing dependencies

To install the dependencies, please use: `pip3 install -r requirements.txt`

## How to run

To run the project:

1. ???

```sh
$ ??
```

## URL to public GitHub repo

https://github.com/LaraTunc/wcd-7-kubernetes

## Dockerhub Image

https://hub.docker.com/repository/docker/laratunc/simple_flask_app/general

## Docs

- [Building multi platform images](https://docs.docker.com/build/building/multi-platform/)
- `docker buildx build --platform linux/amd64,linux/arm64 -t <username>/<image> --push .`
