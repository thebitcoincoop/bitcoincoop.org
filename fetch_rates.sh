curl https://api.bitcoinaverage.com/exchanges/CAD > /var/www/bitcoincoop.org/cad.json
curl https://api.bitcoinaverage.com/exchanges/USD > /var/www/bitcoincoop.org/usd.json
curl "http://rate-exchange.appspot.com/currency?from=USD&to=CAD" > /var/www/bitcoincoop.org/usd_cad.json 
