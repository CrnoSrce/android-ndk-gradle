android-ndk-gradle
This is a Dockerfile to build an Android project using gradle. It includes the NDK and CMake which are the current standard way to build projects with native code.

To compile your Android gradle-based project:
cd /your/project/dir
docker run -it --rm -v $(pwd):/home/user/project -w /home/user/project -u $(id -u):$(id -g) crnosrce/android-ndk-gradle gradle build

Substitute whichever gradle command you want to use in place of "build".

You can also run using a shared gradle cache on the host to avoid redownloading gradle on every build:

docker run -it --rm -v $(pwd):/home/user/project -e "GRADLE_USER_HOME=/home/user/.gradle" -v /host/path/to/gradle/cache:/home/user/.gradle -w /home/user/project -u $(id -u):$(id -g) crnosrce/android-ndk-gradle gradle build
