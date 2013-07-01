
# Module dependencies.

express     	= require 'express'
helpers     	= require 'view-helpers'
CoffeeScript 	= require 'coffee-script'
stylus			= require 'stylus'
assets			= require 'connect-assets'

# BARE for coffe script!
assets.jsCompilers.coffee.compileSync = (sourcePath, source) ->
	CoffeeScript.compile source, {filename: sourcePath, bare: true}


module.exports = (app) ->

	app.configure () ->

		config 		= app.get('config')
		constants 	= app.get('constants')
		env	 		= app.get('env')

		app.use express.static(constants.ROOT + '/public')
		app.set 'views', constants.ROOT + '/app/views'
		app.set 'view engine', 'jade'

		# assets
		app.use assets(src: constants.ROOT + "/public")
		
		# dynamic helpers
		app.use helpers(config.app.name)

		# bodyParser should be above methodOverride
		app.use express.bodyParser()
		app.use express.methodOverride()

		# cookieParser should be above session
		app.use express.cookieParser()

		# routes should be at the last
		app.use app.router

		# use express favicon
		app.use express.favicon()

		# use express logger
		app.use express.logger('dev')

		# production error handler
		if env is 'prod' or env is 'master'

			app.use (err, req, res, next) ->

				console.error err.stack
				res.status 500
				res.render 'error', { error: err }


		# custom error handler
		# app.use (err, req, res, next) ->
		# 		if ~err.message.indexOf('not found') then return next()
		# 		console.log err.stack
		# 		res.status(500).render('500')
		

		# 404 error handler
		app.use (req, res, next) ->

			res.status(404)
			res.render '404', { url: req.originalUrl }
	

 
