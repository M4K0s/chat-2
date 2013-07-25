
colors 	= require 'colors'
mongoose = require 'mongoose'
async 	= require 'async'


module.exports = (app) ->

	config = app.get('config')
	constants = app.get('constants')
	env = app.get('env')

	colors.setTheme constants.COLORS

	Messages = mongoose.model 'Messages'

	actions = 

		index: (req,res) ->

			if !mongoose.connection.readyState
				res.status 500
				res.render 'error', { error: 'db connection error' }

			else 

				Messages.find {},(err,messages) ->

					#res.send "#{err}".error if err 

					#console.log "DB - select : #{messages}".db

					if req.route.path is '/m/chat'
						res.render 'mobile/index',{messages:messages}
					else
						res.render 'chat/index',{messages:messages}

		test: (req, res) ->

			if !mongoose.connection.readyState
				res.status 500
				res.render 'error', { error: 'db connection error' }

			else 

				#Messages.remove {content:""},(err, result) ->
				Messages.remove {},(err, result) ->

					res.console "#{err}".error if err 

					console.log "DB - delete : #{result}".db

					res.send("DB - delete: #{result}");


