
mongoose = require 'mongoose'
async 	= require 'async'

env 		= process.env.NODE_ENV || 'development'
config	= require('../../config/config')[env]
colors 	= require 'colors'
colors.setTheme config.colors

Messages = mongoose.model 'Messages'

exports.index = (req, res) ->

	###
	silence = new Kitten {name: 'Silence'}

	
	rilence = new Kitten {name: 'Rilence'}

	rilence.save (err) ->
		if err then handleError err
	###

	###
	query 	= Kitten.find {name: /ilence/i}
	promise 	= query.exec()
	promise.addBack (err, docs)->
		console.log docs
	###


	#Kitten.remove {name: 'Vins'},(err)->
	#Kitten.remove {name: 'Silence'},(err)->

	#Messages.create {username: 'Vins', content: 'Hello world!'},(err)->

	#Messages.find {},(err,docs)->

		#console.log docs

	#Messages.remove {},(err)->


	Messages.find {},(err,messages) ->

		#res.render '500' if err 

		res.send "#{err}".error if err 

		#console.log "DB - select : #{messages}".db

		if req.route.path is '/m/chat'
			res.render 'mobile/index',{ messages: messages }
		else
			res.render 'chat/index',{ messages: messages }

	

	#res.render 'chat/index',{}


exports.test = (req, res) ->

	Messages.remove {content:""},(err, result) ->

		res.console "#{err}".error if err 

		console.log "DB - delete : #{result}".db

		res.send('done');


