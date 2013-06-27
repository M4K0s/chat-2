

# Module dependencies.


express 	= require 'express'
http 		= require 'http'
io 		= require 'socket.io'
colors 	= require 'colors'
mongoose = require 'mongoose'
fs 		= require('fs')

config	= require('./config/config')[env]

port 		= process.env.PORT || config.port
env 		= process.env.NODE_ENV || 'development'


passport = undefined

colors.setTheme config.colors

app = express()

# models
modelsPath = __dirname + '/app/models'
fs.readdirSync(modelsPath).forEach (file) ->
	require modelsPath+'/'+file

# application settings
require('./config/express')(app, config, passport)

# routes
require('./config/routes')(app, config, passport)


#run server

server = http.createServer app

server.listen port

console.log "SERVER RUN - listening on port port #{port}".server


#io

io = io.listen server

ioPath = __dirname + '/app/io'
fs.readdirSync(ioPath).forEach (file) =>
	require(ioPath+'/'+file)(io, config)

# db 

mongoose.connect config.db

db = mongoose.connection

db.on 'error', () -> console.log 'DB - connection error!'.error

db.once 'open', () -> console.log 'DB - connection success!'.db



# expose app
exports = module.exports = app

