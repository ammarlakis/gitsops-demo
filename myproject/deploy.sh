#!/bin/sh

setopt -e

ENVIRONMENT=$1

echo "Deploying to environment $ENVIRONMENT"
echo "Showing environment variables including secrets, something you should not do:"
env
