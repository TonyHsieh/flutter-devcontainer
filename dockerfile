FROM ubuntu:20.04
# to prevent the interactive problems - like the one asking for a TimeZone
ARG DEBIAN_FRONTEND=noninteractive
# this didn't seem like it was needed.  Never tried to see if it breaks anything.
#ARG TZ=Etc/UTC-7

# Prerequisites
# Using apt-get instead of apt..
#apt update && apt upgrade -y && apt install -y curl git unzip xz-utils zip libglu1-mesa wget openjdk-8-jdk-headless -qq > /dev/null
RUN apt-get update 
#RUN apt upgrade -y
RUN apt-get install -y curl 
RUN apt-get install -y git
RUN apt-get install -y unzip
RUN apt-get install -y xz-utils
RUN apt-get install -y zip
RUN apt-get install -y libglu1-mesa 
RUN apt-get install -y wget
RUN apt-get install -y clang
RUN apt-get install -y cmake 
RUN apt-get install -y ninja-build
RUN apt-get install -y pkg-config 
RUN apt-get install -y libgtk-3-dev
RUN apt-get install -y openjdk-21-jdk
#RUN apt install -y openjdk-21-jdk-headless -qq > /dev/null 

# Prerequisites for Android Studio
#RUN apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libz2-1.0:i386

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
#RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
#RUN unzip sdk-tools.zip && rm sdk-tools.zip
#RUN mv tools Android/sdk/tools
#RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
#RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
##RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
#RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "cmdline-tools;v5" "platform-tools;android-29" "platforms;android-29" "sources;android-29"
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mkdir -p Android/sdk/cmdline-tools/latest
RUN mv cmdline-tools/* Android/sdk/cmdline-tools/latest
RUN cd Android/sdk/cmdline-tools/latest/bin && yes | ./sdkmanager --licenses
#RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
RUN cd Android/sdk/cmdline-tools/latest/bin && ./sdkmanager "build-tools;29.0.2" "cmdline-tools;5.0" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run accept the android-licenses
RUN flutter doctor --android-licenses

# Run basic check
RUN flutter doctor 
