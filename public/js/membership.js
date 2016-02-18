;(function(e,t,n){function i(n,s){if(!t[n]){if(!e[n]){var o=typeof require=="function"&&require;if(!s&&o)return o(n,!0);if(r)return r(n,!0);throw new Error("Cannot find module '"+n+"'")}var u=t[n]={exports:{}};e[n][0](function(t){var r=e[n][1][t];return i(r?r:t)},u,u.exports)}return t[n].exports}var r=typeof require=="function"&&require;for(var s=0;s<n.length;s++)i(n[s]);return i})({1:[function(require,module,exports){
(function() {
  var g, listen;

  g = this;

  $(function() {
    g.attempts = 0;
    listen();
    $('form#register').validator();
    $('#name').focus();
    $.get('/js/rates.json', function(data) {
      var price, rate;
      price = 20;
      rate = data.CAD.quadrigacx.rates.bid;
      g.amount = parseFloat(price / rate).toFixed(8);
      g.address = '19t1bzQ9M5furTQrsaJZr6j9BGE2oUwX3a';
      $('#amount').html(g.amount.toString());
      $('#payment_address').html(g.address);
      $('#qr').html('');
      return new QRCode('qr', {
        text: "bitcoin:" + g.address + "?amount=" + g.amount,
        width: 250,
        height: 250
      });
    });
    $('#register').submit(function(e) {
      e.preventDefault();
      $('.form-control').blur();
      if ($('#register .has-error').length > 0) {
        $('#register .has-error').effect('shake', 500);
        return;
      }
      return $('#modal').modal();
    });
    return $('#qr').click(function() {
      var url;
      url = "bitcoin:" + g.address + "?amount=" + (g.amount.toString());
      return $('<a></a>').attr('href', url).click();
    });
  });

  listen = function() {
    g.attempts++;
    if (g.blockchain && g.blockchain.readyState === 1) {
      return setTimeout(listen, 12000);
    } else {
      if (g.attempts > 3) {
        fail(SOCKET_FAIL);
      }
      g.blockchain = new WebSocket("wss://ws.blockchain.info/inv");
      g.blockchain.onopen = function() {
        if (g.blockchain.readyState === 1) {
          g.attempts = 0;
          $('#payment_error').hide();
          $('#payment_request').show();
          return g.blockchain.send('{"op":"addr_sub", "addr":"' + g.address + '"}');
        } else {
          return setTimeout(g.blockchain.onopen, 12000 * g.attempts);
        }
      };
      g.blockchain.onerror = function() {
        $('#payment_request').hide();
        $('#payment_error').show()('<div class="alert alert-error">Error connecting to payment server, try refreshing the page or trying again later.  Please contact info@bitcoincoop.org if the problem persists.</div>');
        g.blockchain.close();
        delete g.blockchain;
        return listen();
      };
      g.blockchain.onclose = function() {
        delete g.blockchain;
        return listen();
      };
      return g.blockchain.onmessage = function(e) {
        var amount, results, txid;
        results = eval('(' + e.data + ')');
        amount = 0;
        txid = results.x.hash;
        $('#txid').val(txid);
        if (txid === g.last) {
          return;
        }
        g.last = txid;
        $.each(results.x.out, function(i, v) {
          if (v.addr === g.address) {
            return amount += v.value / 100000000;
          }
        });
        if (amount >= g.amount) {
          $('#date').val(moment().format('MMMM Do YYYY, h:mm:ss a'));
          return $.post('/users', $('#register').serializeObject(), function() {
            $('#paid').show();
            return $('#payment_request').hide();
          });
        }
      };
    }
  };

}).call(this);


},{}]},{},[1])
;