exports.new = (req, res) ->
  res.render('calculator/setup',  js: (-> global.js), css: (-> global.css))

exports.show = (req, res) ->
  res.render('calculator/show', 
    js: (-> global.js), 
    css: (-> global.css),
  )
