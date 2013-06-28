
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

		config = app.get('config')
		constants = app.get('constants')
		env = app.get('env')


		app.set 'showStackError', true
		app.use express.static(constants.ROOT + '/public')
		app.use express.logger('dev')
		app.set 'views', constants.ROOT + '/app/views'
		app.set 'view engine', 'jade'

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

		# error handler development only
		if  env is 'dev' or env is 'master'
			app.use express.errorHandler()

		# custom error handler
		###
		app.use (err, req, res, next) ->
			if ~err.message.indexOf('not found') then return next()
			console.log err.stack
			res.status(500).render('500')
		###
		

		app.use (req, res, next) ->
			res.status(404).render('404', { url: req.originalUrl })
	

 
