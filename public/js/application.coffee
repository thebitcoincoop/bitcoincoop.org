#= require bootstrap.min.js

$(->
  $('.panel').hover(
    (-> $(this).find('.img').removeClass('grayscale')),
    (-> $(this).find('.img').addClass('grayscale'))
  )

  $('#register').click(->
    $('#modal').modal()
  )
)

