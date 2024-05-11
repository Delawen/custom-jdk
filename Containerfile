FROM quay.io/fedora/fedora:40
RUN dnf -y update; dnf -y install git java-22-openjdk-devel gcc autoconf automake binutils glibc-devel make libtool pkgconf unzip zip gcc-c++ alsa-lib-devel cups-devel fontconfig-devel libXtst-devel libXt-devel libXrender-devel libXrandr-devel libXi-devel --nodocs; dnf -y clean all
RUN git version; git clone --branch premain --depth 1 https://github.com/openjdk/leyden.git
WORKDIR "/leyden"
#TODO: explore with more configuration tuning, e.g. --enable-jvm-feature-cds --disable-jvm-feature-epsilongc --disable-jvm-feature-management --disable-jvm-feature-parallelgc --enable-jvm-feature-services --enable-jvm-feature-jvmti --disable-jvm-feature-jvmci --disable-jvm-feature-vm-structs --disable-jvm-feature-jni-check --disable-jvm-feature-zero --disable-jvm-feature-zgc --enable-generate-classlist --disable-manpages --with-vendor-name=Experiments
RUN bash configure --disable-warnings-as-errors --disable-jvm-feature-parallelgc --disable-jvm-feature-epsilongc --disable-jvm-feature-zero --disable-jvm-feature-zgc --enable-generate-classlist
#TODO: use also configure --with-classpath, modules, jlink
#RUN bash configure --help
RUN make images

FROM quay.io/fedora/fedora:40
RUN dnf -y update; dnf -y install git --nodocs; dnf -y clean all
COPY --from=0 /leyden/build/linux-x86_64-server-release/images/jdk /leyden-openjdk
WORKDIR "/leyden-openjdk/bin"
RUN ./java --version
RUN mkdir -p "/quarkus"
WORKDIR "/quarkus"
RUN git clone --branch main --depth 1 https://github.com/quarkusio/quarkus-quickstarts.git
WORKDIR "/quarkus/quarkus-quickstarts/getting-started"
ENV JAVA_HOME=/leyden-openjdk
ENV JDK_HOME=$JAVA_HOME
ENV JAVA_BINDIR=$JAVA_HOME"/bin"
ENV JAVA_ROOT=$JAVA_HOME
ENV PATH=$JAVA_BINDIR:$PATH
RUN ./mvnw package
