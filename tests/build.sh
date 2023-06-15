#!/usr/bin/env bash

pwd=$(pwd)

mv $pwd/docker/* $pwd/

docker build . --tag elestio4test/automatisch:latest
