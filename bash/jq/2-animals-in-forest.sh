#!/bin/bash

cat animals.json | jq -r '.animals[] | select(.habitat | test("^forest$"; "i")) | .name'
