#!/bin/bash
cd "$(dirname "$0")"

export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mix deps.get
mix compile
cd assets
npm install
webpack --mode production
cd ..
mix phx.digest

echo "Generating release..."
mix release

echo "Starting app...";
PORT=4790 MIX_ENV=prod mix phx.server;