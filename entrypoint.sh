#!/bin/sh

if [ $# -eq 0 ]; then
	echo "No command was given to run, exiting."
	exit 1
else
	# Start Xvfb
	echo "Starting Xvfb"
	Xvfb ${DISPLAY} -ac -screen 0 "$XVFB_WHD" -nolisten tcp &

	echo "Waiting for Xvfb to be ready..."
	while ! xdpyinfo -display ${DISPLAY} > /dev/null 2>&1; do
  		sleep 0.1
	done
	echo "...done."

	exec "$@"
fi
