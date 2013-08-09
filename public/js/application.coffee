$(->
  $.getJSON('http://pos.bitcoincoop.org/ticker',
    symbol: 'virtexCAD',
    type: 'ask',
    amount: 1000
    (data) ->
      price = parseFloat(data) * 1.05 
      $('#ask').text(price.toFixed(2)) 
  )

  $.getJSON('http://pos.bitcoincoop.org/ticker',
    symbol: 'virtexCAD',
    type: 'bid',
    amount: 1000
    (data) ->
      price = parseFloat(data) * 0.95
      $('#bid').text(price.toFixed(2)) 
  )
)
