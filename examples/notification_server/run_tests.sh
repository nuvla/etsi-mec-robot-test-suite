#!/bin/sh -e

python -m robot --outputdir ./logs/ \
                --loglevel TRACE \
                ./tests