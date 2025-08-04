#!/bin/bash

cat animals.json | jq -r '.animals[] | select(.name | test("^penguin$"; "i")) | .foods[]'
