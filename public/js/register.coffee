$(->
  $.get('/users', (data) ->
    for member in data
      $('#members').append("<tr><td>#{member.number}</td><td>#{member.name}</td></tr>")
  )
)
