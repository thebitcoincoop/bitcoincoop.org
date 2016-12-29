g = this
$(->
  g.attempts = 0
  listen()

  $('form#register').validator()
  $('#name').focus()

  $.get('/js/rates.json', (data) ->
    price = 20
    rate = data.CAD.quadrigacx.rates.bid
    g.amount = parseFloat(price / rate).toFixed(8)
    g.address = '37dAD5j5D8Z4mskdujeFNXuPMfeVBDF2qB'

    $('#amount').html(g.amount.toString())
    $('#payment_address').html(g.address)

    $('#qr').html('')
    new QRCode('qr', 
      text: "bitcoin:#{g.address}?amount=#{g.amount}"
      width: 250
      height: 250
    )
  )

  $('#register').submit((e) ->
    e.preventDefault()

    $('.form-control').blur()
    if $('#register .has-error').length > 0
      $('#register .has-error').effect('shake', 500)
      return

    $('#modal').modal()
  )

  $('#qr').click(->
    # $.post('/users', $('#register').serializeObject(), ->
    #  $('#paid').show()
    #  $('#payment_request').hide()
    # )
    # return 

    url = "bitcoin:#{g.address}?amount=#{g.amount.toString()}"
    $('<a></a>').attr('href', url).click() 
  )

)

listen = ->
  g.attempts++
  if g.blockchain and g.blockchain.readyState is 1
    setTimeout(listen, 12000)
  else
    fail(SOCKET_FAIL) if g.attempts > 3
    g.blockchain = new WebSocket("wss://ws.blockchain.info/inv")

    g.blockchain.onopen = -> 
      if g.blockchain.readyState is 1
        g.attempts = 0
        $('#payment_error').hide()
        $('#payment_request').show()
        g.blockchain.send('{"op":"addr_sub", "addr":"' + g.address + '"}')
      else
        setTimeout(g.blockchain.onopen, 12000 * g.attempts)
    
    g.blockchain.onerror =  ->
      $('#payment_request').hide()
      $('#payment_error').show()('<div class="alert alert-error">Error connecting to payment server, try refreshing the page or trying again later.  Please contact info@bitcoincoop.org if the problem persists.</div>')
      g.blockchain.close()
      delete g.blockchain
      listen()

    g.blockchain.onclose = ->
      delete g.blockchain
      listen()

    g.blockchain.onmessage = (e) ->
      results = eval('(' + e.data + ')')
      amount = 0
      txid = results.x.hash
      $('#txid').val(txid)

      return if txid == g.last
      g.last = txid
      
      $.each(results.x.out, (i, v) ->
        if (v.addr == g.address) 
          amount += v.value / 100000000
      )

      if amount >= g.amount
        $('#date').val(moment().format('MMMM Do YYYY, h:mm:ss a'))

        $.post('/users', $('#register').serializeObject(), ->
          $('#paid').show()
          $('#payment_request').hide()
        )
