
mongoose = require 'mongoose'

env 		= process.env.NODE_ENV || 'development'
config	= require('../../config/config')[env]
colors 	= require 'colors'
colors.setTheme config.colors

exports.index = (req, res) ->

	if req.route.path is '/m'
		res.render 'home/index_m',{}
	else
		res.render 'home/index',{}
