#!/usr/bin/env bash

# fail this script immediately if any command fails with a non-zero exit code
set -e
# Treat unset env variables as an error
set -u
# fail on pipeline errors, e.g. when grepping
set -o pipefail

# see http://stackoverflow.com/a/246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_SRC_HOME="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# allow to set these parameters explicitly (although we could do this also directly, this is a bit more convenient)
HEAP_SIZE="1g"
CLIENTS="8"
PIPELINE="from-sources"

# TODO: We need to be able to vary index settings as well
for i in "$@"
do
case ${i} in
    --skip-build)
    PIPELINE="from-sources-skip-build"
    shift # past argument with no value
    ;;
    --heap=*)
    HEAP_SIZE="${i#*=}"
    shift # past argument=value
    ;;
    --clients=*)
    CLIENTS="${i#*=}"
    shift # past argument=value
    ;;
    # Do not consume unknown parameters?
    #*)
esac
done


# TODO: Vary track / challenge (i.e. what about query benchmarks?)

# on-error=abort: this ensures we will not continue when an error has happened (e.g. node out of memory)

# sometimes it might make sense to skip the build?
rally --track="geonames" \
      --challenge="append-no-conflicts-index-only" \
      --team-path="${SCRIPT_SRC_HOME}/es-config" \
      --car="defaults" \
      --on-error="abort" \
      --revision="current" \
      --pipeline="${PIPELINE}" \
      --car-params="heap_size:'${HEAP_SIZE}'" \
      --track-params="bulk_indexing_clients:${CLIENTS}"