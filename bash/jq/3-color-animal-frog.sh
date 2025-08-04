#!/bin/bash

cat animals.json | jq -r '.animals[] | select(.name | test("^frog$"; "i")) | .color'
