# Overview

![IBM ACE logo](./app_connect_light_256x256.png)

[IBM® App Connect Enterprise](https://developer.ibm.com/integration/docs/app-connect-enterprise/faq/) command environment in a container.

## Building a container image

**Important:** Only ACE version **12.0.1.0 or greater** is supported.

Before building the image you must obtain a copy of the relavent build of ACE and make it available on a HTTP endpoint.

When using an insecure http endpoint, build the image using a command such as:

```bash
docker build -t ace --build-arg DOWNLOAD_URL=${DOWNLOAD_URL}  --file ./Dockerfile .
```

If you want to connect to a secure endpoint build the image using a command such as:
i.e.

```bash
docker build -t ace --build-arg USERNAME=<Username> --build-arg PASSWORD=<Password> --build-arg DOWNLOAD_URL=${DOWNLOAD_URL}  --file ./Dockerfile .
```

NOTE: If no DOWNLOAD_URL is provided the build will use a copy of the App Connect Enterprise developer edition as referenced in the Dockerfile

### Running the image

To run the image use a command such as

`docker run -it <image:tag>`

## Pre-Built Containers

Pre-built images can be found on Docker Hub - [ireshmm/ace-builder](https://hub.docker.com/repository/docker/ireshmm/ace-builder)
