

# Module dependencies.


express 	= require 'express'
http 		= require 'http'
io 		= require 'socket.io'
colors 	= require 'colors'
mongoose = require 'mongoose'
fs 		= require 'fs'


module.exports = (env) ->

	config		= require('./config/config')[env]

	constants 	= require('./config/constants')

	port 		= config.port

	colors.setTheme constants.COLORS

	app = express()

	app.set('env', env)
	app.set('constants', constants)
	app.set('config', config)


	# application settings
	require('./config/express')(app)

	# models
	modelsPath = __dirname + '/app/models'
	fs.readdirSync(modelsPath).forEach (file) ->
		require modelsPath+'/'+file

	# controllers
	controllersPath = __dirname + '/app/controllers'
	fs.readdirSync(controllersPath).forEach (file) ->
		require(controllersPath+'/'+file)(app)


	#run server

	server = http.createServer app

	server.listen port

	console.log "Server #{env} is running - listening on port port #{port}".server


	#run io

	io = io.listen server

	ioPath = __dirname + '/app/io'
	fs.readdirSync(ioPath).forEach (file) =>
		require(ioPath+'/'+file)(app, io)

		console.log "------>" + file
		#for route in require('../../config/routes')['controllers']['chat']
			#app.get route.url, actions[route.action]


	# db

	mongoose.connect config.db
	db = mongoose.connection

	db.on 'error', () ->

		console.log 'DB connection error!'.error

	db.once 'open', () ->

		console.log 'DB connection success!'.db
