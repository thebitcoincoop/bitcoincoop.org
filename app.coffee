fs = require('fs')
express = require('express')
path = require('path')
engines = require('consolidate')
request = require('request')

merchants = require("./routes/merchants")
calculator = require("./routes/calculator")

app = express()
app.enable('trust proxy')
app.engine('html', require('mmm').__express)
app.set('view engine', 'html')
app.set('views', __dirname + '/views')
app.use(express.static(__dirname + '/public'))
app.use(require('connect-assets')(src: 'public'))
app.use(express.bodyParser())
app.use(express.cookieParser())
app.use(app.router)

do fetchRates = ->
  request("https://api.bitcoinaverage.com/exchanges/all", (error, response, body) ->
    try 
      require('util').isDate(JSON.parse(body).timestamp)
      file = 'public/js/rates.json'
      stream = fs.createWriteStream(file)
      fs.truncate(file, 0, ->
        stream.write(body)
      )
  )
  setTimeout(fetchRates, 120000)

routes =
  "/": 'index'
  "/about": 'about'
  "/directors": 'directors'
  "/education": 'education'
  "/coinos": 'coinos'
  "/exchangers": 'exchangers'
  "/exchangers/join": 'join'
  "/membership": 'membership'
  "/merchants": 'merchants'
  "/merchants/signup": 'signup'
  "/contact": 'contact'
  "/partners": 'partners'
  "/coinfest": 'coinfest'


for route, view of routes
  ((route, view) ->
    app.get(route, (req, res) ->
      res.render(view,
        js: (-> global.js),
        css: (-> global.css),
        layout: 'layout',
      )
    )
  )(route, view)


app.get('/bc/*', (req, res) ->
  res.send(req.path)
  res.end()
)

app.get('/merchants2', merchants.list)

app.get('/claim/:id', (req, res) ->
  account = (i for i in require('./accounts.json').accounts when i.id is req.params.id)[0]

  res.render('claim',
    js: (-> global.js),
    css: (-> global.css),
    layout: 'layout',
    address: account.address,
    amount: account.amount,
    rupees: 500,
    url: account.link
  )
)

app.post('/users', (req, res) ->
  db = require('./redis')

  errormsg = ""
  userkey = "member:"+req.body.email
  db.hgetall(userkey, (err, obj) ->
    if obj
      errormsg += "Email exists"

    if errormsg
      return res.render('membership',
        layout: 'layout',
        js: (-> global.js), 
        css: (-> global.css),
        error: errormsg
      )

    db.sadd("users",userkey)
    db.hmset(userkey,
      name: req.body.name,
      email: req.body.email,
      address: req.body.address
    )

    if process.env.NODE_ENV is 'production'
      res.render('users/welcome', 
        layout: 'mail',
        js: (-> global.js), 
        css: (-> global.css),
        (err, html) ->
          sendgrid = require('sendgrid')(config.sendgrid_user, config.sendgrid_password)

          email = new sendgrid.Email(
            to: req.body.email
            from: 'everyone@bitcoincoop.org'
            subject: 'Welcome to the Co-op!'
            html: html
          )

          sendgrid.send(email)
      )
  )
)

app.post('/contact', (req, res) ->
  nodemailer = require("nodemailer")
  transport = nodemailer.createTransport("Sendmail", "/usr/sbin/sendmail")

  mailOptions =
    from: "The Bitcoin Co-op <info@bitcoincoop.org>",
    to: "info@bitcoincoop.org",
    subject: "Contact Form",
    html: JSON.stringify(req.body)

  transport.sendMail(mailOptions, (error, response) ->
    console.log(error) if(error)
    smtpTransport.close()
  )

  res.render('thanks',
    js: (-> global.js),
    css: (-> global.css),
    layout: 'layout'
  )
)

app.get('/ticker', calculator.ticker)

app.use((err, req, res, next) ->
  res.status(500)
  console.log(err)
  res.end()
)

app.listen(3002)
