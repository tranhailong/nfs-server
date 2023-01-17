#!/bin/bash
# the sudo mount not working for some reason, figure out later

setup() {
./scripts/build.sh
./scripts/run.sh
}

teardown() {
./scripts/teardown.sh
}

setup()
sudo mount -t nfs -v localhost:/share $(pwd)/volumes/test
ls volumes/test

touch volumes/test/test1
if [ ! -f volumes/share/test1 ]; then
  echo "TEST 1: FAILED - write on client, check on server"
  else
  echo "TEST 1: PASSED - write on client, check on server"
fi
touch volumes/share/test2
if [ ! -f volumes/test/test2 ]; then
  echo "TEST 2: FAILED - write on server, check on client"
  else
  echo "TEST 2: PASSED - write on server, check on client"
fi

sudo umount -v $(pwd)/volumes/test
teardown()

