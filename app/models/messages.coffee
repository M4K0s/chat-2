
# Module dependencies.

env = process.env.NODE_ENV || 'development'

config 		= require('../../config/config')[env]
constants 	= require('../../config/constants')

mongoose = require 'mongoose'

Messages = new mongoose.Schema {

	date: 
		type: Date
		default: Date.now 

	uid: Number
	username: String
	avatar: String
	content: String

}


module.exports = mongoose.model 'Messages', Messages