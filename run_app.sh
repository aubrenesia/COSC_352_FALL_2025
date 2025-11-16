#!/bin/bash
docker build -t baltimore-homicides-app ./docker
docker run -p 3838:3838 baltimore-homicides-app
