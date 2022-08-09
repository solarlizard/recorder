#!/bin/bash

./stop.sh

docker-compose -f ./docker-compose.yml up --build

./stop.sh
