
# Module dependencies.

express     	= require 'express'
mongoStore  	= require('connect-mongo')(express)
helpers     	= require 'view-helpers'
CoffeeScript 	= require 'coffee-script'
stylus			= require 'stylus'
assets			= require 'connect-assets'

# BARE for coffe script!
assets.jsCompilers.coffee.compileSync = (sourcePath, source) ->
	CoffeeScript.compile source, {filename: sourcePath, bare: true}


module.exports = (app, config, passport) ->

	app.configure () ->

		app.set 'showStackError', true
		app.use express.static(config.root + '/public')
		app.use express.logger('dev')
		app.set 'views', config.root + '/app/views'
		app.set 'view engine', 'jade'

		app.use assets(src: config.root + "/public")
		

		# dynamic helpers
		app.use helpers(config.app.name)

		# bodyParser should be above methodOverride
		app.use express.bodyParser()
		app.use express.methodOverride()

		# cookieParser should be above session
		app.use express.cookieParser()

		app.use express.session {
			secret: config.app.name
			store: new mongoStore {
			  url: config.db
			  collection : 'sessions'
			}
		}

		if passport
			app.use passport.initialize()
			app.use passport.session()
		

		# routes should be at the last
		app.use app.router

		# use express favicon
		app.use express.favicon()

		# error handler development only
		if 'development' == app.get('env')
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
	

 
