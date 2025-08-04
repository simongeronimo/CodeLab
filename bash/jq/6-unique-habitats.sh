#!/bin/bash

cat animals.json | jq -r '[.animals[].habitat] | unique[]'
