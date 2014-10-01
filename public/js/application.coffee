#= require bootstrap.min.js
#= require items.coffee

$(->
  $(document).on('click', '.plus, .minus', (e) -> 
    e.stopPropagation()

    span = $(this).siblings('.lead')
    count = parseInt(span.html())
    total = parseInt($(this).closest('.items').find('h3 .count').html())
    max = parseInt($(this).closest('.items').find('.max').html())

    n = 1
    n = -1 if $(this).hasClass('minus')

    return if count is 0 and n is -1
    return if total is max and n is 1
    count += n

    img = $(this).closest('.item').find('.img')
    img.toggleClass('grayscale', count is 0)
    span.html(count.toString())

    updateTotals()
  )

  updateTotals = ->
    $('.items').each(->
      count = 0
      $(this).find('div.item span.count').each(-> 
        count += parseInt($(this).html())
      )
      $(this).find('h3 span.count').html(count.toString())
    )

  $(document).on('click', '.item', -> $(this).find('.plus').click())

  $('#register-button').click(->
    $('#modal').modal()
  )

  $('#modal').on('shown.bs.modal', ->
    $('#email').focus()
  )

  $('#modal').on('hidden.bs.modal', ->
    $.post('/users', $('#register').serialize())
  )

  $('#order').submit(->
    order = "BEEF"
    $.post('/orders', order: order)
    return false
  )

  for item in window.items
    div = $('.item').first().clone()
    div.removeAttr('id')
    div.find('.img').css('background-image', "url(#{item.image})")
    div.find('.name').html(item.name)
    div.find('.description').html(item.description)
    div.find('.ingredients').html(item.ingredients.toString())
    div.show()

    switch item.type
      when 'Entree'
        $('#entrees').append(div)
      when 'Soup'
        $('#soups').append(div)
      when 'Salad'
        $('#salads').append(div)

  $('#item').remove()
)

