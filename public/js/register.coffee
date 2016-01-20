$(->
  $.get('/users', (data) ->
    for member in JSON.parse(data)
      $('#members tbody').append("<tr><td>#{member.number}</td><td>#{member.name}</td></tr>")
  )
)
