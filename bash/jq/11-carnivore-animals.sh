#!/bin/bash

cat animals.json | jq -r '.animals[] | select(.foods | unique[] | test("^meat$"; "i")) | .name'
