fs = require('fs')
express = require('express')
path = require('path')
engines = require('consolidate')
request = require('request')
config = require('./config')

app = express()
app.enable('trust proxy')
app.engine('html', require('mmm').__express)
app.set('view engine', 'html')
app.set('views', __dirname + '/views')
app.use(express.static(__dirname + '/public'))
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
  '/': 'index'
  '/about': 'about'
  '/coinfest': 'coinfest'
  '/coinos': 'coinos'
  '/contact': 'contact'
  '/directors': 'directors'
  '/membership': 'membership'
  '/merchants': 'merchants'
  '/partners': 'partners'
  '/register': 'register'


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

app.get('/users', (req, res) ->
  db = require('./redis')
  db.keys('member:*', (err, keys) ->
    users = []

    for key, i in keys 
      do (i, db) ->
        db.hgetall(key, (err, user) ->
          unless user.private
            users.push(user)

          if i >= keys.length - 1
            users.sort((a,b) -> 
              return -1 if a.number < b.number
              return 1 if a.number > b.number
              return 0
            )
            res.write(JSON.stringify(users))
            res.end()
        )
  )
)

app.post('/users', (req, res) ->
  db = require('./redis')

  userkey = "member:"+req.body.email
  db.hgetall(userkey, (err, obj) ->

    if obj
      res.status(500).send("Sorry, that email address is already registered")
      return

    db.sadd("users",userkey)
    db.incr('members', (err, number) ->
      db.hmset(userkey,
        name: req.body.name
        email: req.body.email
        address: req.body.address
        number: number
        date: req.body.date
        txid: req.body.txid
        (err, obj) ->
          if true or process.env.NODE_ENV is 'production'
            email = req.body.email
            res.render('welcome', 
              layout: 'mail',
              js: (-> global.js), 
              css: (-> global.css),
              (err, html) ->
                sendgrid = require('sendgrid')(config.sendgrid_user, config.sendgrid_password)

                email = new sendgrid.Email(
                  to: email
                  from: 'info@bitcoincoop.org'
                  subject: 'Welcome to the Co-op!'
                  html: html
                )

                sendgrid.send(email)
            )

          res.end()
        )
    )
  )
)

app.get('/ticker', (req, res) ->
  fs = require('fs')

  fs.readFile("./public/js/rates.json", (err, data) ->
    req.query.currency ||= 'CAD'
    req.query.symbol ||= 'quadrigacx'
    req.query.type ||= 'bid'

    try 
      exchange = JSON.parse(data)[req.query.currency][req.query.symbol]['rates'][req.query.type].toString()
    catch e 
      exchange = "0"

    res.writeHead(200, 
      'Content-Length': exchange.length,
      'Content-Type': 'text/plain')
    res.write(exchange)
    res.end()
  )
)

app.use((err, req, res, next) ->
  res.status(500)
  console.log(err)
  res.end()
)

app.listen(3002)
