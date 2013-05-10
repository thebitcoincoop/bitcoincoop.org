express = require('express')
path = require('path')
engines = require('consolidate')
passport = require('./passport')

calculator = require("./routes/calculator")
sessions = require("./routes/sessions")(passport)
transactions = require("./routes/transactions")
users = require("./routes/users")(sessions)

app = express()
app.enable('trust proxy')
app.engine('html', require('mmm').__express)
app.set('view engine', 'html')
app.set('views', __dirname + '/views')
app.use(express.static(__dirname + '/public'))
app.use(require('connect-assets')(src: 'public'))
app.use(express.bodyParser())
app.use(express.cookieParser())
app.use(passport.initialize())
app.use(app.router)

routes =
  "/": 'main/index'
  "/about": 'main/about'
  "/exchangers": 'main/exchangers'
  "/exchangers/join": 'main/join'
  "/merchants": 'main/merchants'
  "/merchants/signup": 'main/signup'
  "/contact": 'main/contact'

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

app.use((err, req, res, next) ->
  res.status(500)
  console.log(err)
  res.end()
)

app.listen(3002)
