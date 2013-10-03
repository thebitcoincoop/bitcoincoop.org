db = require("redis").createClient()

module.exports =
	list: (req, res) ->
		db.smembers("mts", (err, keys) ->
			mts = []
			for mt in keys
				db.hgetall(mt, (err, it) ->
					mts.push(it)
					if keys.length==mts.length
						console.log(mts)
						ulist=[]
						counter=0;
						db.smembers('users', (err, obj) ->
							for user in obj
								db.hgetall(user, (err,ufields) ->
									if ufields!=null
										ulist[ufields["company"]]=ufields
									counter++
									if obj.length==counter									
										ordered=[]
										keys=[]
										for k,v of ulist
											keys.push(k)
											keys = keys.sort()
										for key in keys
											ordered.push(ulist[key])
										res.render('merchants2', 
											mtypes: mts,
											userlist: ordered,
											js: (-> global.js), 
											css: (-> global.css), 
											layout: 'layout'
										)	
								)
						)
				)
		)