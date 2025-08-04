#!/bin/bash

cat animals.json | jq '[.animals[]] | length'
