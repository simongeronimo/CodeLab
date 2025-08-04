#!/bin/bash

cat animals.json | jq '.animals[] | select(.color | test("o"; "i")) | "\(.name) = \(.color | gsub("(?i)o"; " [O] "))"'
