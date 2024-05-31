#!/usr/bin/env bash

#Build the fedora base image, an up to date Fedora 40 with no extras:
buildah build --cache-ttl=480h --pull=missing --layers -f FedoraBase -t fedora-base .

#Build the "fedora with dev tools" base image:
buildah build --cache-ttl=480h --pull=missing --layers -f FedoraWithDevTools -t fedora-with-dev .

#Can enter its shell to (optionally) inspect the container with:
#podman run -it localhost/fedora-with-dev bash

#Build Leyden JDK, latest from premain branch:
buildah build --cache-ttl=480h --pull=missing --layers -f LeydenBuildContainerfile -t leyden-build .

#Bootstrap the Quarkus app using the CDS+Leyden archives:
#podman run -it localhost/leyden-build:latest
echo "Now run>  podman run -it localhost/leyden-build:latest"

#fedorafull=$(buildah build --cache-ttl=480h --pull=missing --layers -f BeefyContainerfile -t fedora-full .)

#echo "Built 'fedora full' build image as $fedorafull"



#fedora-full=$(buildah build --cache-ttl=480h --layers -f BeefyContainerfile -t fedora-full .)

# Build the container using the definition in `Containerfile`
## Setting 30 days for cache expiry for layers for now, as we don't need strict
## freshness while exploring things, and this greatly facilitates travel and offline work.
#buildah build --cache-ttl=480h --layers -f Containerfile -t leyden-quarkus-quickstart .

## Include some buildtime annotations (example):
#buildah config --annotation "io.quarkus.core-version=TODO_SET_THIS" "$ctr1"
