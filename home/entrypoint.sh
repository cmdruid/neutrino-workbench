#!/usr/bin/env sh
## Entrypoint Script

set -E

###############################################################################
# Environment
###############################################################################

CMD="lnd"
CONF_FILE="/config/lnd.conf"
PASS_FILE="$DATA/.cookie"

[ -z "$NETWORK" ] && NETWORK="testnet"
[ -z "$REST_PORT" ] && REST_PORT="8080"

export NETWORK
export REST_PORT
export PARAM_FILE="$DATA/.params"
export REST_HOST="$DATA/.resthost"
export START_LOG="$DATA/start.log"

###############################################################################
# Methods
###############################################################################

init() {
  ## Execute startup scripts.
  for script in `find /root/home/start -name *.*.sh | sort`; do
    $script; state="$?"
    [ $state -ne 0 ] && exit $state
  done
}

###############################################################################
# Main
###############################################################################

## Ensure all files are executable.
for FILE in $PWD/bin/*   ; do chmod a+x $FILE; done
for FILE in $PWD/start/* ; do chmod a+x $FILE; done

## Check if binary exists.
[ -z "$(which $CMD)" ] && (echo "$CMD file is missing!" && exit 1)

## Make sure temp files is empty.
printf "" > $START_LOG
printf "" > $PARAM_FILE
rm $REST_HOST

## Run init scripts.
init

## If hostname is not set, use container address as default.
[ ! -f "$REST_HOST" ] && printf "https://$(hostname -I | tr -d ' '):$REST_PORT" > "$REST_HOST"

## Format variable if set.
if [ -n "$WALLET_PW" ]; then
  printf "$WALLET_PW" > $PASS_FILE
  WALLET_CONF="--wallet-unlock-password-file=$PASS_FILE"
fi

## Construct final params string.
PARAMS="\
--bitcoin.active \
--bitcoin.$NETWORK \
--bitcoin.node=neutrino \
--configfile=$CONF_FILE \
$(cat $PARAM_FILE) $WALLET_CONF $@"

## Execute main binary.
printf "[ $(date "+%D | %r") ]\nExecuting $CMD with params:\n" > $START_LOG
for param in $PARAMS; do echo $param >> $START_LOG; done && echo

## Start lightningd.
$CMD $PARAMS
