#!/bin/sh
# Plain HTTP on the port Railway injects: the edge terminates TLS, and Railway's healthcheck dials
# the injected PORT, so the app has to listen there.
export HTTPS=OFF
export HTTP_PORT="${PORT:-8080}"
exec /init "$@"
