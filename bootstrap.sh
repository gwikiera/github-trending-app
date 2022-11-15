#!/bin/bash

# local variables
IS_RUNNING_ON_CI="${CI:-false}"
FAILURE_OUTPUT_COLOR='\033[0;31m'
SUCCESS_OUTPUT_COLOR='\033[0;32m'
NO_OUTPUT_COLOR='\033[0m'

if [[ "$IS_RUNNING_ON_CI" = false ]]; then
	# it's necessary to make resolving packages graph work after project generation
	echo "${SUCCESS_OUTPUT_COLOR}Killing Xcode to make Resolving Package Graph work."
	kill $(ps aux | grep 'Xcode' | awk '{print $2}')
	echo "Killed Xcode."
fi

# code generation
mkdir -p Trending/Generated/
mkdir -p DesignSystem/Sources/DesignSystem/Generated/

swiftgen
 
# project generation
xcodegen generate

if [[ "$IS_RUNNING_ON_CI" = false ]]; then
	# it's necessary to make resolving packages graph work after project generation
	echo 'Opening Xcode...'
	xed .
fi