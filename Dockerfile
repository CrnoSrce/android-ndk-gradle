FROM openjdk:8

####
## Android setup
####

# Set up environment variables
ENV GRADLE_VERSION 4.4
ENV USER_NAME=user
ENV USER_HOME_DIR=/home/$USER_NAME
ENV ANDROID_HOME="$USER_HOME_DIR/android-sdk"
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
ENV GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"

# Start as root to create the user's work directory, etc
USER root

# To silence the build message about this file being missing
RUN mkdir -p /$USER_NAME/.android/ && touch /$USER_NAME/.android/repositories.cfg

# Create a non-root user
RUN useradd -m $USER_NAME
RUN chown $USER_NAME /$USER_NAME
USER $USER_NAME
WORKDIR $USER_HOME_DIR

# Download Android SDK + NDK
ENV ANDROID_NDK "ndk-bundle" "cmake;3.6.4111459" "lldb;2.3"
ENV ANDROID_BUILD_TOOLS "build-tools;27.0.3"
ENV CONSTRAINT_LAYOUT "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta2"
RUN mkdir "$ANDROID_HOME" .android \
 && mkdir -p $USER_HOME_DIR/.android/ && touch $USER_HOME_DIR/.android/repositories.cfg \
 && cd "$ANDROID_HOME" \
 && wget $SDK_URL -O sdk.zip \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses \
 && yes | ${ANDROID_HOME}/tools/bin/sdkmanager --update \
 && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --verbose $ANDROID_NDK \
 && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --verbose $ANDROID_BUILD_TOOLS \
 && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --verbose $CONSTRAINT_LAYOUT
ENV ANDROID_NDK_HOME ${ANDROID_HOME}/ndk-bundle

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-$GRADLE_VERSION gradle \
 && rm gradle.zip \
 && mkdir .gradle

ENV PATH="$USER_HOME_DIR/gradle/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"
