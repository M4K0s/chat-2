
# Module dependencies.


mongoose 		= require 'mongoose'
env 				= process.env.NODE_ENV || 'development'
config 			= require('../../config/config')[env]

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