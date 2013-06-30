
mongoose = require 'mongoose'
async 	= require 'async'
colors 	= require 'colors'

module.exports = (app,io) ->

	config = app.get('config')
	constants = app.get('constants')
	env = app.get('env')


	colors.setTheme constants.COLORS

	Messages = mongoose.model 'Messages'

	Chat = io.of('/chat').on 'connection', (socket) ->

		# store users
		Chat.users = {}
		Chat.channels = {}

		# when the client emits 'adduser', this listens and executes
		socket.on 'adduser', (data) =>

			# store in the socket session for this client

			socket.user = {

				id: data.uid
				name: data.username
				avatar: data.avatar

			}

			channel = socket.channel

			socket.channelPrivate = channel+'-private-'+socket.user.id

			Chat.users[socket.user.id] = {uid: socket.user.id, username: socket.user.name, avatar: socket.user.avatar, channel: channel, channelPrivate: socket.channelPrivate}

			console.log """
			ADD USER
			#{JSON.stringify(Chat.users)}

			""".info

			socket.join( socket.channelPrivate )

			# echo to client they've connected
			socket.emit('updatechat', 'SERVER', 'you have connected to ' + channel)
			#socket.emit('updatechat', 'SERVER', 'you have has connected to ' + socket.channelReactor)
			#socket.emit('updatechat', 'SERVER', 'you have has connected to ' + socket.channelPrivate)

			# echo to channel 1 that a person has connected to their channel
			socket.broadcast.to( channel ).emit('updatechat', 'SERVER', socket.user.name + ' has connected to ' + channel)
			
			#socket.emit('updatechannels', channels, channel )

			# update the list of users in chat, client-side
			Chat.to( channel ).emit('updateusers', Chat.users)



		socket.on 'addchannel', (cid, channel) =>

			socket.channel 	= channel
			socket.cid 			= cid

			socket.channelReactor = channel+'-reactor'
			
			Chat.channels[cid] = {cid: cid, channel: channel, channelReactor: socket.channelReactor}

			socket.join( socket.channel )
			socket.join( socket.channelReactor )

			console.log """
			ADD CHANNEL
			#{JSON.stringify(Chat.channels)}

			""".io


		# when the client emits 'sendchat', this listens and executes
		socket.on 'sendchat', (res) =>
			# we tell the client to execute 'updatechat'

			req = {
				uid: socket.user.id
				username: socket.user.name
				avatar: socket.user.avatar
				content: res.content
			}

			console.log req

			
			Messages.create req,(err)->

				console.log "DB - insert : #{err}".error if err
				console.log "DB - insert : #{JSON.stringify(req)}".db

				Chat.in(socket.channel).emit('updatechat','USER', req)
			

		socket.on 'switchchannel', (newchannel, channels) =>
			# leave the current channel (stored in session)
			socket.leave(socket.channel)
		
			# join new channel, received as function parameter
			socket.join(newchannel)
			socket.emit('updatechat', 'SERVER', 'you have connected to '+ newchannel)
			# sent message to OLD channel
			socket.broadcast.to(socket.channel).emit('updatechat', 'SERVER', socket.username+' has left this channel')
			# update socket session channel title
			socket.channel = newchannel
			socket.broadcast.to(newchannel).emit('updatechat', 'SERVER', socket.username+' has joined this channel')
			socket.emit('updatechannels', channels, newchannel)



		# when the user disconnects.. perform this
		socket.on 'disconnect', () =>

			if socket.user

				console.log """
				USER DISCONNECTTED
				uid: #{JSON.stringify(socket.user.id)}

				""".io

				# remove the username from global usernames list
				delete Chat.users[socket.user.id]
				delete Chat.channels[socket.cid]

				# update list of users in chat, client-side
				io.sockets.emit('updateusers', Chat.users)

				# echo globally that this client has left
				socket.broadcast.emit('updatechat', 'SERVER', socket.user.name + ' has disconnected')

				socket.leave(socket.channel)
				socket.leave(socket.channelReactor)
				socket.leave(socket.channelPrivate)