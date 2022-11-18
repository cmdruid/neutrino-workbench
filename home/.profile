## This file can be used to customize your environment.
## Feel free to add your own aliases and shortcuts!

## Run .init on login.
[ -f '/root/home/.init' ] && . /root/home/.init

## Configure bitcoin-cli.
alias lncli="lncli --network=$NETWORK"

## Useful for checking open sockets.
alias listen='lsof -i -P -n | grep LISTEN'

## Shortcuts to logfiles.
debug() { 
  tail -f "/root/.lnd/logs/bitcoin/$NETWORK/lnd.log"
}

## Get QR codes for exporting complex strings.
qrcode() {
  [ "$#" -ne 0 ] && input="$1" || input="$(tr -d '\0' < /dev/stdin)"
  echo && qrencode -m 2 -t "UTF8" "$input" && printf "${input}\n\n"
}

base64url() {
  [ "$#" -ne 0 ] && input="$1" || input="$(tr -d '\0' < /dev/stdin)"
  printf "$input" | base64 -w 0 | tr "+" "-" | tr "/" "_"
}

macaroon() {
  MACAROON_FILE="/root/.lnd/data/chain/bitcoin/$NETWORK/admin.macaroon"
  cat $MACAROON_FILE | tr -d '\0' | xxd -ps -u -c 1000
}

## Print out LND admin macaroon.
lndconnect() {
  [ -z "$REST_HOST" ] && REST_HOST=127.0.0.1
  [ -z "$REST_PORT" ] && REST_PORT=443
  MACAROON_FILE="/root/.lnd/data/chain/bitcoin/$NETWORK/admin.macaroon"
  ENCODED_CERT="$(openssl x509 -outform der -in /root/.lnd/tls.cert | base64url)"
  MACAROON="$(cat $MACAROON_FILE | base64url)"
  echo "lndconnect://$REST_HOST:$REST_PORT?macaroon=$MACAROON" | qrcode
}
