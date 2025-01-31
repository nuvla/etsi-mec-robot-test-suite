#!/bin/bash

# Function to display usage message
usage() {
    echo "Usage: $0 testname"
    exit 1
}

if [ "$#" -ne 1 ]; then
    usage
fi

testname=$1

if [ -f "$testname" ]; then
    full_dir_path=$(dirname "$(realpath "$testname")")
    echo "Running the test: $(realpath "$testname")"
else
    echo "The file '$testname' does not exist."
    exit 1
fi

script_dir_path=$(dirname "$(realpath "$0")")
root_path="${script_dir_path}/../"

docker run --rm -it --name etsi-ttf-robot \
  -v "${root_path}":/home/robot \
  --workdir "/home/robot/" \
  -e TEST_FILE="${testname}" \
  ttf-robot-img:latest \
  python -m robot -X "${TEST_FILE}"
