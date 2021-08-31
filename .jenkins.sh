#!/bin/bash
# Copyright ETSI 2018
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -vx
#set -e

cd "$(dirname "$0")"

run_dir="$(pwd)"

echo "Using git branch $GIT_BRANCH"

./scripts/build-container.sh
./scripts/run-container.sh "${run_dir}"

if [[ "$GIT_BRANCH" =~ .*fix-plu$ ]]; then

	apiTestsVersion=$(echo $GIT_BRANCH | cut -d'/' -f 2)
	apiTestsVersion=$(echo $apiTestsVersion | cut -d'-' -f 1)
	echo apiTestsVersion
	
	curl -X POST \
     -F token=${ROBOT_HIVE_TAP_TT_TOKEN} \
     -F ref=master \
     -F "variables[API_TESTS_VERSION]=$apiTestsVersion" \
     -F "variables[TEST_SUITE]=MEC" \
     https://forge.etsi.org/rep/api/v4/projects/484/trigger/pipeline
fi
ret=$?
echo "Final validation result: $ret"
exit $ret
