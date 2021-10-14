# ----------------------------------------------------------------------------
#
# Package		: mockito
# Version		: 2.28.2
# Source repo		: https://github.com/mockito/mockito.git
# Tested on		: UBI 8.0
# Script License	: MIT License
# Maintainer		: Manik Fulpagar <manik.fulpagar@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#			  
# ----------------------------------------------------------------------------

#!/bin/bash

# variables
PKG_NAME="mockito"
PKG_VERSION=v2.28.2
PKG_VERSION_LATEST=v3.12.3
REPOSITORY="https://github.com/mockito/mockito.git"

echo "Usage: $0 [v<PKG_VERSION>]"
echo "       PKG_VERSION is an optional paramater whose default value is v2.28.2"

PKG_VERSION="${1:-$PKG_VERSION}"

# install tools and dependent packages
yum -y update
yum install -y git wget curl unzip nano vim make dos2unix

# setup java environment
yum install -y java-11 java-devel

which java
ls /usr/lib/jvm/
export JAVA_HOME=/usr/lib/jvm/$(ls /usr/lib/jvm/ | grep -P '^(?=.*java-11)(?=.*ppc64le)')
echo "JAVA_HOME is $JAVA_HOME"
# update the path env. variable 
export PATH=$PATH:$JAVA_HOME/bin

# install gradle 
GRADLE_VERSION=6.2.2
wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
mkdir -p usr/local/gradle
unzip -d /usr/local/gradle gradle-$GRADLE_VERSION-bin.zip
ls usr/local/gradle/gradle-$GRADLE_VERSION/
rm -rf gradle-$GRADLE_VERSION-bin.zip
export GRADLE_HOME=/usr/local/gradle
# update the path env. variable 
export PATH=$PATH:$GRADLE_HOME/gradle-$GRADLE_VERSION/bin

# create folder for saving logs 
mkdir -p /logs
LOGS_DIRECTORY=/logs

LOCAL_DIRECTORY=/root

# clone, build and test latest version
cd $LOCAL_DIRECTORY
git clone $REPOSITORY $PKG_NAME-$PKG_VERSION
cd $PKG_NAME-$PKG_VERSION/
git checkout $PKG_VERSION

echo "skipCodegen=true" >> ./gradle.properties
echo "skipAndroid=true" >> ./gradle.properties

#./gradlew build

gradle build | tee $LOGS_DIRECTORY/$PKG_NAME-$PKG_VERSION.txt
