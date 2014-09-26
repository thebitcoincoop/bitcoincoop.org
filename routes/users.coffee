new: (req, res) ->
  create: (req, res) ->
    errormsg = ""
    userkey = "farm:"+req.body.email
    db.hgetall(userkey, (err, obj) ->
      if obj
        errormsg += "Email already registered"

      if req.body.confirm != req.body.password
        errormsg += "Passwords must match"

      if errormsg
        return res.render('users/new',
          layout: 'layout',
          js: (-> global.js), 
          css: (-> global.css),
          error: errormsg
        )

      bcrypt.hash(req.body.password, 12, (err, hash) ->
         db.hmset(userkey,
           password: hash,
           email: req.body.email,
           phone: req.body.phone,
           address: req.body.address
          , ->
            req.session.redirect = "/#{req.body.username}/edit"
            sessions.create(req, res)
         )
      )

      require('crypto').randomBytes(48, (ex, buf) ->
        token = buf.toString('base64').replace(/\//g,'').replace(/\+/g,'')
        db.set("token:#{token}", req.body.username)
        host = req.hostname
        host += ':3000' if host is 'localhost'
        url = "#{req.protocol}://#{host}/verify/#{token}"

        res.render('users/welcome', 
          user: req.params.user, 
          layout: 'mail',
          url: url,
          privkey: req.body.privkey,
          js: (-> global.js), 
          css: (-> global.css),
          (err, html) ->
            sendgrid = require('sendgrid')(config.sendgrid_user, config.sendgrid_password)

            email = new sendgrid.Email(
              to: req.body.email
              from: 'adam@coinos.io'
              subject: 'Welcome to CoinOS'
              html: html
            )

            sendgrid.send(email)
        )
      )
    )

  edit: (req, res) ->
    res.render('users/edit', 
      user: req.params.user, 
      layout: 'layout',
      navigation: true,
      js: (-> global.js), 
      css: (-> global.css)
    )
