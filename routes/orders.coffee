db = require('../redis')

module.exports = ->
  create: (req, res) ->
    db.set("order:#{req.body.email}:#{req.body.week}", req.body.order, ->
      req.session.redirect = "/#{req.body.username}/edit"
      sessions.create(req, res)
    )

    res.render('order', 
      user: req.params.user, 
      layout: 'mail',
      order: req.body.order,
      js: (-> global.js), 
      css: (-> global.css),
      (err, html) ->
        sendgrid = require('sendgrid')(config.sendgrid_user, config.sendgrid_password)

        email = new sendgrid.Email(
          to: req.body.email
          from: 'sea.green@gmail.com'
          subject: 'Karma Farma Order'
          html: html
        )

        sendgrid.send(email)
    )
