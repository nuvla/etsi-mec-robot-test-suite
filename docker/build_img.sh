#!/bin/bash

script_dir_path=$(dirname "$(realpath "$0")")
dockerfile_path="${script_dir_path}/Dockerfile"
docker build -f "${dockerfile_path}" "${script_dir_path}/.." -t ttf-robot-img:latest

