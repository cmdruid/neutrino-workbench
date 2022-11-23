#!/usr/bin/env sh
## Ngrok init script.

set -E

API_HOST="localhost:4040/api/tunnels"

###############################################################################
# Main
###############################################################################

if [ -n "$NGROK_ENABLED" ] && [ -n "$NGROK_TOKEN" ]; then

  echo "Initializing Ngrok"

  ## Add auth token to ngrok config and start Ngrok.
  ngrok config add-authtoken "$NGROK_TOKEN"
  tmux new -d -s ngrok "ngrok http https://127.0.0.1:$REST_PORT" && sleep 2
  
  ## Call API to get NGROK host, and save formatted host string.
  NGROK_HOST="$(curl -s $API_HOST | jq -r .tunnels[0].public_url | tr -d 'https://')"
  printf "$NGROK_HOST:443" > "$REST_HOST"
fi
