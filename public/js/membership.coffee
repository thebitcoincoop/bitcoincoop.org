g = this
$(->
  $.get('/js/rates.json', (data) ->
    g.rates = data

    price = 0.04 
    rate = g.rates.CAD.quadrigacx.rates.bid
    g.amount = parseFloat(price / rate).toFixed(8)
    g.address = '15dRBzyg68NXRraGQVpa4MgbohyZEFH7sM'

    $('#amount').html(g.amount.toString())
    $('#address').html(g.address)

    $('#qr').html('')
    new QRCode('qr', 
      text: "bitcoin:#{g.address}?amount=#{g.amount}"
      width: 250
      height: 250
    )
  )

  $('#register').submit((e) ->
    e.preventDefault()
    $('#modal').modal()
  )

  setTimeout(listen, 60000) unless g.blockchain
)

listen = ->
  unless g.blockchain and g.blockchain.readyState is 1
    g.blockchain = new WebSocket("wss://ws.blockchain.info/inv")

    g.blockchain.onopen = -> 
      $('#payment_error').hide()
      $('#payment_request').show()
      g.blockchain.send('{"op":"addr_sub", "addr":"' + g.address + '"}')
    
    g.blockchain.onerror = (err) ->
      $('#payment_request').hide()
      $('#payment_error').show()('<div class="alert alert-error">Error connecting to payment server, try refreshing the page or trying again later.  Please contact info@bitcoincoop.org if the problem persists.</div>')
      g.blockchain = null

    g.blockchain.onclose = ->
      $('#payment_request').html('<div class="alert alert-error">Error connecting to payment server, try refreshing the page or trying again later.  Please contact info@bitcoincoop.org if the problem persists.</div>')
      g.blockchain = null

    g.blockchain.onmessage = (e) ->
      results = eval('(' + e.data + ')')
      amount = 0
      txid = results.x.hash

      $.each(results.x.out, (i, v) ->
        if (v.addr == g.address) 
          amount += v.value / 100000000
      )

      if amount >= g.amount
        $('#paid').show()
        $('#payment_request').hide()
        $('#register').unbind('submit').submit()
