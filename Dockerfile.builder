FROM debian:stretch

# Real base shit
RUN apt-get update && \
    apt-get install -y ca-certificates apt-transport-https gnupg curl

# Dev stuff
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y pbuilder build-essential openjdk-8-jdk bazel debootstrap
