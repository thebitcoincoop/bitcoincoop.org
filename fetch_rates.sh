DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl https://api.bitcoinaverage.com/exchanges/CAD > $DIR/cad.json
curl https://api.bitcoinaverage.com/exchanges/USD > $DIR/usd.json
curl "http://rate-exchange.appspot.com/currency?from=USD&to=CAD" > $DIR/usd_cad.json 
