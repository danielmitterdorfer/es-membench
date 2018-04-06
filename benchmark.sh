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
PIPELINE="from-sources"
TELEMETRY_OPTS=""
TRACK="geonames"
CHALLENGE="append-no-conflicts-index-only"

for i in "$@"
do
case ${i} in
    --skip-build)
    PIPELINE="from-sources-skip-build"
    shift # past argument with no value
    ;;
    --profile)
    # the 'profile' template is included by default and also does allocation profiling.
    TELEMETRY="--telemetry=jfr --telemetry-params=\"recording-template:'profile'\""
    shift # past argument with no value
    ;;
    --track=*)
    TRACK="${i#*=}"
    shift # past argument=value
    ;;
    --challenge=*)
    CHALLENGE="${i#*=}"
    shift # past argument=value
    ;;
    --heap=*)
    HEAP_SIZE="${i#*=}"
    shift # past argument=value
    ;;
    # Do not consume unknown parameters?
    #*)
esac
done


# on-error=abort: this ensures we will not continue when an error has happened (e.g. node out of memory)
rally --track="${TRACK}" \
      --challenge="${CHALLENGE}" \
      --team-path="${SCRIPT_SRC_HOME}/es-config" \
      --car="defaults" \
      --on-error="abort" \
      --revision="current" \
      --pipeline="${PIPELINE}" \
      --car-params="heap_size:'${HEAP_SIZE}'" \
      --track-params="${SCRIPT_SRC_HOME}/track-params.json" \
      ${TELEMETRY_OPTS}