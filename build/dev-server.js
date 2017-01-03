require('./check-versions')()
var config = require('../config')
if (!process.env.NODE_ENV) process.env.NODE_ENV = JSON.parse(config.dev.env.NODE_ENV)
var path = require('path')
var express = require('express')
var webpack = require('webpack')
var opn = require('opn')
var proxyMiddleware = require('http-proxy-middleware')
var webpackConfig = process.env.NODE_ENV === 'testing'
  ? require('./webpack.prod.conf')
  : require('./webpack.dev.conf')

// default port where dev server listens for incoming traffic
var port = process.env.PORT || config.dev.port
// Define HTTP proxies to your custom API backend
// https://github.com/chimurai/http-proxy-middleware
var proxyTable = config.dev.proxyTable

var app = express()
var compiler = webpack(webpackConfig)

var devMiddleware = require('webpack-dev-middleware')(compiler, {
  publicPath: webpackConfig.output.publicPath,
  stats: {
    colors: true,
    chunks: false
  }
})

var hotMiddleware = require('webpack-hot-middleware')(compiler)
// force page reload when html-webpack-plugin template changes
compiler.plugin('compilation', function (compilation) {
  compilation.plugin('html-webpack-plugin-after-emit', function (data, cb) {
    hotMiddleware.publish({ action: 'reload' })
    cb()
  })
})

// proxy api requests
Object.keys(proxyTable).forEach(function (context) {
  var options = proxyTable[context]
  if (typeof options === 'string') {
    options = { target: options }
  }
  app.use(proxyMiddleware(context, options))
})

// handle fallback for HTML5 history API
app.use(require('connect-history-api-fallback')())

// serve webpack bundle output
app.use(devMiddleware)

// enable hot-reload and state-preserving
// compilation error display
app.use(hotMiddleware)

// serve pure static assets
var staticPath = path.posix.join(config.dev.assetsPublicPath, config.dev.assetsSubDirectory)
app.use(staticPath, express.static('./static'))

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
              return -1 if parseInt(a.number) < parseInt(b.number)
              return 1 if parseInt(a.number) > parseInt(b.number)
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

module.exports = app.listen(port, function (err) {
  if (err) {
    console.log(err)
    return
  }
  var uri = 'http://localhost:' + port
  console.log('Listening at ' + uri + '\n')
})
