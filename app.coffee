

# Module dependencies.


express 	= require 'express'
http 		= require 'http'
io 			= require 'socket.io'
colors 		= require 'colors'
mongoose 	= require 'mongoose'
fs 			= require 'fs'
path 		= require 'path'


module.exports = (env,port) ->

	config		= require('./config/config')[env]
	constants 	= require('./config/constants')

	colors.setTheme constants.COLORS

	console.log "\n   App #{env} on port #{port} init".silly

	app = express()

	app.set 'env', env
	app.set 'port', port
	app.set 'constants', constants
	app.set 'config', config

	# application settings
	require('./config/express')(app)

	# models
	modelsPath = __dirname + '/app/models'
	fs.readdirSync(modelsPath).forEach (file) ->
		require modelsPath+'/'+file


	routes 	= require('./config/routes')

	# controllers
	controllersPath = __dirname + '/app/controllers'

	console.log "\n   init Routes".info

	fs.readdirSync(controllersPath).forEach (file) ->

		controller = require(controllersPath+'/'+file)(app)

		filename = path.basename(file, '.coffee')

		if routes.controllers[filename]

			for route in routes.controllers[filename]

				console.log "   --> Url: '#{route.url}' | Controller: '#{filename}' | Action: '#{route.action}'".data

				if controller[route.action]
					app.get route.url, controller[route.action]
				else
					console.log "   Warn! Action '#{route.action}' not found in Controller '#{filename}', but exists in /config/routes".warn

		else
			console.log "   Warn! Controller '#{filename}' not found in /config/routes".warn

	#run server

	server = http.createServer app
	server.listen port

	console.log "\n   Server #{env} is running - listening on port port #{port}\n".info
	
	#run io
	io = io.listen server
	ioPath = __dirname + '/app/io'
	fs.readdirSync(ioPath).forEach (file) =>
		require(ioPath+'/'+file)(app, io)


	# db
	mongoose.connect config.db
	db = mongoose.connection

	
	db.on 'error', () ->

		console.log '\n   DB connection error!\n'.error
	
	db.once 'open', () ->

		console.log '\n   DB connection success!\n'.info


	

