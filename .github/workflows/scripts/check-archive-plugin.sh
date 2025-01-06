#!/bin/bash
##===----------------------------------------------------------------------===##
##
## This source file is part of the SwiftAWSLambdaRuntime open source project
##
## Copyright (c) 2017-2024 Apple Inc. and the SwiftAWSLambdaRuntime project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.txt for the list of SwiftAWSLambdaRuntime project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

EXAMPLE=HelloWorld
OUTPUT_DIR=.build/plugins/AWSLambdaPackager/outputs/AWSLambdaPackager
OUTPUT_FILE=${OUTPUT_DIR}/MyLambda/bootstrap
ZIP_FILE=${OUTPUT_DIR}/MyLambda/MyLambda.zip

pushd Examples/${EXAMPLE} || exit 1

# package the example (docker and swift toolchain are installed on the GH runner)
LAMBDA_USE_LOCAL_DEPS=../.. swift package archive --allow-network-connections docker || exit 1

# did the plugin generated a Linux binary?
[ -f "${OUTPUT_FILE}" ]
file "${OUTPUT_FILE}" | grep --silent ELF

# did the plugin created a ZIP file?
[ -f "${ZIP_FILE}" ]

# does the ZIP file contain the bootstrap?
unzip -l "${ZIP_FILE}" | grep --silent bootstrap

echo "✅ The archive plugin is OK"
popd || exit 1