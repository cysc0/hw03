#!/bin/bash

# Source: Nat Tuck - http://khoury.neu.edu/~ntuck/courses/2019/01/cs4550/notes/05-frontend-intro/

export PORT=4790
export MIX_ENV=prod
# export NODEBIN=`pwd`/assets/node_modules/.bin
# export PATH="$PATH:$NODEBIN"
export GIT_PATH=/home/practice/hw03

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "practice" ]; then
	echo "Error: must run as user 'practice'"
	echo "  Current user is $USER"
	exit 2
fi

echo "Building..."

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
MIX_ENV=prod mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/hw03 ]; then
	echo mv ~/www/hw03 ~/old/$NOW
	mv ~/www/hw03 ~/old/$NOW
fi

mkdir -p ~/www/hw03
REL_TAR=~/src/hw03/_build/prod/rel/memory/releases/0.0.1/hw03.tar.gz
(cd ~/www/hw03 && tar xzvf $REL_TAR)

#. start.sh
