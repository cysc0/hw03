#!/bin/bash
cd "$(dirname "$0")"

PORT=4790 MIX_ENV=prod mix phx.server;