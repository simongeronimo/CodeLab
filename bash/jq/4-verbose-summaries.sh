#!/bin/bash

cat animals.json | jq '.animals[] | "The \(.name) is \(.size) and \(.color)"'
