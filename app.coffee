fs = require('fs')
express = require('express')
path = require('path')
engines = require('consolidate')

merchants = require("./routes/merchants")
calculator = require("./routes/calculator")

setRates = (req, res, next) ->
  usd_to_cad = require("./usd_cad.json").rate
  bitstamp_commission = 0.05
  virtex_commission = 0.05

  fs.readFile("./cad.json", (err, data) ->
    virtex_ask = JSON.parse(data).cavirtex.rates.ask
    virtex_ask *= 1 + virtex_commission
    virtex_bid = JSON.parse(data).cavirtex.rates.bid
    virtex_bid *= 1 - virtex_commission

    fs.readFile("./usd.json", (err, data) ->
      bitstamp_ask = JSON.parse(data).bitstamp.rates.ask
      bitstamp_ask *= 1 + bitstamp_commission
      bitstamp_bid = JSON.parse(data).bitstamp.rates.bid
      bitstamp_bid *= 1 - bitstamp_commission

      app.locals.sell = Math.max(virtex_ask, bitstamp_ask * usd_to_cad).toFixed(2)
      app.locals.buy = Math.min(virtex_bid, bitstamp_bid * usd_to_cad).toFixed(2)

      next()
    )
  )

app = express()
app.enable('trust proxy')
app.engine('html', require('mmm').__express)
app.set('view engine', 'html')
app.set('views', __dirname + '/views')
app.use(express.static(__dirname + '/public'))
app.use(require('connect-assets')(src: 'public'))
app.use(express.bodyParser())
app.use(express.cookieParser())
app.use(setRates)
app.use(app.router)

routes =
  "/": 'index'
  "/about": 'about'
  "/education": 'education'
  "/exchangers": 'exchangers'
  "/exchangers/join": 'join'
  "/merchants": 'merchants'
  "/merchants/signup": 'signup'
  "/contact": 'contact'


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
