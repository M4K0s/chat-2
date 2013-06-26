
# Module dependencies.

module.exports = (app, config, passport) ->

	home = require '../app/controllers/home'

	app.get '/', home.index
	app.get '/m', home.index

	chat = require '../app/controllers/chat'

	app.get '/chat', chat.index
	app.get '/m/chat', chat.index
	
	app.get '/test', chat.test




