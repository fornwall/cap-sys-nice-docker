#!/bin/sh
set -e -u

echo "Inspecting /proc/1/status"
grep Cap /proc/1/status

./set-scheduler
