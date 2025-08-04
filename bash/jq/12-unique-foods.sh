#!/bin/bash

cat animals.json | jq -r '[.animals[].foods[]] | unique[]'
