#!/bin/bash

cat animals.json | jq -r '.animals[] | select(.size | test("^small$"; "i")) | .name'
