#!/bin/bash
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

AFNETWORKING_RELATIVE_PATH="AFNetworking"

IPHONEOS_SDK="iphoneos"
IPHONESIMULATOR_SDK="iphonesimulator"

AFNETWORKING_FRAMEWORK_IPHONEOS="${BASEDIR}/${AFNETWORKING_RELATIVE_PATH}/build/${IPHONEOS_SDK}"
AFNETWORKING_FRAMEWORK_IPHONESIMULATOR="${BASEDIR}/${AFNETWORKING_RELATIVE_PATH}/build/${IPHONESIMULATOR_SDK}"

# Go to AFNetworking.framework source code location and build universal static framework.
cd "${AFNETWORKING_RELATIVE_PATH}"

# Produce static frameworks for all processor architectures.
# CONFIGURATION_BUILD_DIR should have absolute path value.
xcodebuild -project AFNetworking.xcodeproj -scheme AFNetworking CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CONFIGURATION_BUILD_DIR="${AFNETWORKING_FRAMEWORK_IPHONEOS}" -configuration release -sdk ${IPHONEOS_SDK} clean build
xcodebuild -project AFNetworking.xcodeproj -scheme AFNetworking CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CONFIGURATION_BUILD_DIR="${AFNETWORKING_FRAMEWORK_IPHONESIMULATOR}" -configuration release -sdk ${IPHONESIMULATOR_SDK} clean build

# Produce static frameworks for all processor architectures.
# Create universal AFNetworking.framework.
lipo -c "${AFNETWORKING_FRAMEWORK_IPHONEOS}/AFNetworking.framework/AFNetworking" "${AFNETWORKING_FRAMEWORK_IPHONESIMULATOR}/AFNetworking.framework/AFNetworking" -o "${AFNETWORKING_FRAMEWORK_IPHONEOS}/AFNetworking.framework/AFNetworking"

# Copy universal AFNetworking.framework to src/ios/.

rm -rf "${BASEDIR}/AFNetworking.framework" && mkdir -p "${BASEDIR}/AFNetworking.framework"
cp -rf "${AFNETWORKING_FRAMEWORK_IPHONEOS}/AFNetworking.framework" "${BASEDIR}"