#!/bin/bash

cd "$(dirname "$0")"
perl ./callsign-lookup.pl "$1" ITU_prefix.txt
