#= require bootstrap.min.js
#= require items.coffee

$(->
  $(document).on(
    mouseenter: (-> $(this).find('.img').removeClass('grayscale'))
    mouseleave: (-> $(this).find('.img').addClass('grayscale'))
    '.panel'
  )

  $('#register').click(->
    $('#modal').modal()
  )

  for item in window.items
    div = $('#item').clone()
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

