
colors 	= require 'colors'
mongoose = require 'mongoose'
async 	= require 'async'

routes 	= require('../../config/routes')['controllers']['chat']


module.exports = (app) ->


	config = app.get('config')
	constants = app.get('constants')
	env = app.get('env')

	colors.setTheme constants.COLORS

	Messages = mongoose.model 'Messages'

	actions = 

		index: (req,res) ->

			messages = []

			Messages.find {},(err,messages) ->

				#res.render '500' if err 

				res.send "#{err}".error if err 

				#console.log "DB - select : #{messages}".db

				if req.route.path is '/m/chat'
					res.render 'mobile/index',{messages:messages}
				else
					res.render 'chat/index',{messages:messages}

		test: (req, res) ->

			Messages.remove {content:""},(err, result) ->

				res.console "#{err}".error if err 

				console.log "DB - delete : #{result}".db

				res.send('done');


	# ===== get Rotes! =====

	for route in routes

		app.get route.url, actions[route.action]

	

