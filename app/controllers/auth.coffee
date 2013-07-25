colors 		= require 'colors'
mongoose 	= require 'mongoose'
async 		= require 'async'
passport	= require 'passport'


module.exports = (app) ->

	config = app.get('config')
	constants = app.get('constants')
	env = app.get('env')

	colors.setTheme constants.COLORS

	# Simple route middleware to ensure user is authenticated.
	# Use this route middleware on any resource that needs to be protected.  If
	# the request is authenticated (typically via a persistent login session),
	# the request will proceed.  Otherwise, the user will be redirected to the
	# login page.

	ensureAuthenticated = (req, res, next) ->
		if req.isAuthenticated() then return next()
		res.redirect '/login'
	

	app.get '/account', ensureAuthenticated, (req, res) ->
		res.render 'account', { user: req.user }


	app.get '/login', (req, res) ->
		res.render 'login', { user: req.user }

	# GET /auth/facebook
	# Use passport.authenticate() as route middleware to authenticate the
	# request.  The first step in Facebook authentication will involve
	# redirecting the user to facebook.com.  After authorization, Facebook will
	# redirect the user back to this application at /auth/facebook/callback

	app.get '/auth/facebook',passport.authenticate('facebook'),(req, res) -> 
		# The request will be redirected to Facebook for authentication, so this
		# function will not be called.


	# GET /auth/facebook/callback
	# Use passport.authenticate() as route middleware to authenticate the
	# request.  If authentication fails, the user will be redirected back to the
	# login page.  Otherwise, the primary route function function will be called,
	# which, in this example, will redirect the user to the home page.

	app.get '/auth/facebook/callback',passport.authenticate('facebook', { failureRedirect: '/login' }),(req, res) ->
		res.redirect('/')

	app.get '/logout', (req, res) ->
		req.logout()
		res.redirect('/')





