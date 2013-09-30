express = require('express')
path = require('path')
engines = require('consolidate')

merchants = require("./routes/merchants")

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

routes =
  "/": 'index'
  "/about": 'about'
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
        layout: 'layout'
      )
    )
  )(route, view) 


app.get('/merchants2', merchants.list)


app.post('/contact', (req, res) ->
  nodemailer = require("nodemailer")
  smtpTransport = nodemailer.createTransport("SMTP",
    service: "Gmail",
    auth:
      user: require('./config').user
      pass: require('./config').pass
  )

  mailOptions = 
    from: "Adam Soltys <asoltys@gmail.com>",
    to: "asoltys@gmail.com",
    subject: "Bitcoin Co-op Contact Form",
    html: JSON.stringify(req.body)

  smtpTransport.sendMail(mailOptions, (error, response) ->
    console.log(error) if(error)
    smtpTransport.close()
  )

  res.render('thanks', 
    js: (-> global.js), 
    css: (-> global.css),
    layout: 'layout'
  )
)

app.get('/ticker', (req, res) ->
  options = 
    host: 'bitcoincharts.com', 
    path: "/t/depthcalc.json?symbol=#{req.query.symbol}&type=#{req.query.type}&amount=#{req.query.amount}&currency=true"

  require('http').get(options, (r) ->
    r.setEncoding('utf-8')
    r.on('data', (chunk) ->
      try
        exchange = req.query.amount / JSON.parse(chunk).out
        exchange = (Math.ceil(exchange * 100) / 100).toString()
      catch e
        exchange = ""

      res.writeHead(200, 
        'Content-Length': exchange.length,
        'Content-Type': 'text/plain')
      res.write(exchange)
      res.end()
    )
  )
)

app.use((err, req, res, next) ->
  res.status(500)
  console.log(err)
  res.end()
)

app.listen(3002)
