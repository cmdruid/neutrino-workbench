## This file can be used to customize your environment.
## Feel free to add your own aliases and shortcuts!

## Set default variables.
[ -z "$NETWORK" ] && NETWORK="testnet"

## Run .init on login.
[ -f '/root/home/.init' ] && . /root/home/.init

## Configure bitcoin-cli.
alias lncli="lncli --network=$NETWORK"

## Useful for checking open sockets.
alias listen='lsof -i -P -n | grep LISTEN'

debug() { 
  ## Shortcut to the logfile.
  tail -f "/root/.lnd/logs/bitcoin/$NETWORK/lnd.log"
}

qrcode() {
  ## Generate a QR code from an input string.
  [ "$#" -ne 0 ] && input="$@" || input="$(tr -d '\0' < /dev/stdin)"
  echo && qrencode -m 2 -t "UTF8" "$input" && printf "${input}\n\n"
}

base64url() {
  ## Encode an input string into base64url.
  [ "$#" -ne 0 ] && input="$@" || input="$(cat /dev/stdin)"
  printf "$input" | base64 -w 0 | tr "+" "-" | tr "/" "_"
}

macaroon() {
  ## Print out the admin macaroon as a hex string.
  MACA_FILE="/root/.lnd/data/chain/bitcoin/$NETWORK/admin.macaroon"
  cat $MACA_FILE | xxd -ps -u -c 1000
}

lndconnect() {
  ## Print out LND connection details as a QR code.
  #ENCODED_CERT="$(openssl x509 -outform der -in /root/.lnd/tls.cert | base64url)"
  REST_HOST="$(cat $DATA/.resthost)"
  MACA_FILE="/root/.lnd/data/chain/bitcoin/$NETWORK/admin.macaroon"
  MACAROON="$(cat $MACA_FILE | base64 -w 0 | tr '+' '-' | tr '/' '_')"
  echo "lndconnect://$REST_HOST?macaroon=$MACAROON" | qrcode
}
