#!/usr/bin/env bash

xhost +local:docker
docker-compose up --detach
docker exec -it palm-dev-env /bin/bash
