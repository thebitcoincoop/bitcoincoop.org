g = this
$(->
  $.get('/js/rates.json', (data) ->
    g.rates = data

    price = 0.04 
    rate = g.rates.CAD.quadrigacx.rates.bid
    g.amount = parseFloat(price / rate).toFixed(8)
    g.address = '15dRBzyg68NXRraGQVpa4MgbohyZEFH7sM'

    $('#payment_details').html("You can pay now by transferring #{g.amount} BTC to:")
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

  setTimeout(listen, 10000) unless g.blockchain
)

listen = ->
  unless g.blockchain and g.blockchain.readyState is 1
    g.blockchain = new WebSocket("wss://ws.blockchain.info/inv")

    g.blockchain.onopen = -> 
      $('#connection').fadeIn().removeClass('glyphicon-exclamation-sign').addClass('glyphicon-signal')
      g.blockchain.send('{"op":"addr_sub", "addr":"' + g.address + '"}')
    
    g.blockchain.onerror = (err) ->
      $('#connection').addClass('glyphicon-exclamation-sign').removeClass('glyphicon-signal')
      g.blockchain = null

    g.blockchain.onclose = ->
      $('#connection').addClass('glyphicon-exclamation-sign').removeClass('glyphicon-signal')
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
        $('#register').unbind('submit').submit()
