DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -k https://api.bitcoinaverage.com/exchanges/CAD > $DIR/cad.json
curl -k https://api.bitcoinaverage.com/exchanges/USD > $DIR/usd.json
curl -k "http://rate-exchange.appspot.com/currency?from=USD&to=CAD" > $DIR/usd_cad.json 
curl "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20%28%22USDCAD%22,%20%22CADUSD%22%29&env=store://datatables.org/alltableswithkeys" > $DIR/usd_cad.xml