db = require("redis").createClient()

module.exports =
   list: (req, res) ->
      ulist=[]
      db.smembers('users', (err, obj) ->
         todo = obj.length
         
         for user in obj
            db.hgetall(user, (err,ufields) ->
               if ufields!=null
                  ulist[ufields["company"]]=ufields
               todo--
               if todo==0
                  ordered=[]
                  keys=[]
                  for k,v of ulist
                  	keys.push(k)
                  keys = keys.sort()
                  for key in keys
                  	ordered.push(ulist[key])
                  res.render('merchants2', 
                      userlist: ordered,
                      js: (-> global.js), 
                      css: (-> global.css), 
                      layout: 'layout'
                  )
            )
      )