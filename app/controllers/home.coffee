

colors 	= require 'colors'
mongoose = require 'mongoose'
async 	= require 'async'

routes 	= require('../../config/routes')['controllers']['home']

module.exports = (app) -> 
	
	
	config = app.get('config')
	constants = app.get('constants')
	env = app.get('env')

	colors.setTheme constants.COLORS

	actions = 

		index: (req,res) ->

			if req.route.path is '/m'
				res.render 'home/index_m',{}
			else
				res.render 'home/index',{}


	# ===== get Rotes! =====

	for route in routes
		
		app.get route.url, actions[route.action]

	

