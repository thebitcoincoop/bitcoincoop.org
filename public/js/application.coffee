#= require bootstrap.min.js
#= require items.coffee

$(->
  $(document).on('click', '.plus, .minus', (e) -> 
    e.stopPropagation()

    span = $(this).siblings('.lead')
    count = parseInt(span.html())

    n = 1
    n = -1 if $(this).hasClass('minus')

    return if count is 0 and n is -1
    count += n

    img = $(this).closest('.item').find('.img')
    img.toggleClass('grayscale', count is 0)

    span.html(count.toString())
  )

  $(document).on('click', '.item', -> $(this).find('.plus').click())

  $('#register').click(->
    $('#modal').modal()
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

