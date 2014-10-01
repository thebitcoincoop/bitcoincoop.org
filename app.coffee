fs = require('fs')
express = require('express')
path = require('path')
engines = require('consolidate')

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

orders = require('./routes/orders')
users = require('./routes/users')

routes =
  "/": 'index'
  "/about": 'about'
  "/contact": 'contact',
  "/register": 'register'


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

app.post('/users', users.create)
app.post('/orders', orders.create)

app.use((err, req, res, next) ->
  res.status(500)
  console.log(err)
  res.end()
)

app.listen(3003)
