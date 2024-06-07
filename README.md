# custom-jdk
Experiment: potential of a customized JDK for Quarkus

## Requirements

We're using buildah to create the container image.
Make sure buildha is installed, then invoke the `build-container.sh` script.

To build all necessary images, run:

    bash build-container.sh

## Testing

To measure impact of the various solutions, run:

    bash measure-boot.sh
