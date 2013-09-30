db = require("redis").createClient()

module.exports =
	list: (req, res) ->
		ulist=[]
		db.smembers('users', (err, obj) ->
			todo = obj.length
			for user in obj
				db.hgetall(user, (err,obj) ->
					todo--
					ulist.push(obj)
					if todo==0
						res.render('merchants2', 
					    	userlist: ulist,
					    	js: (-> global.js), 
					    	css: (-> global.css), 
					    	layout: 'layout'
						)
				)
		)