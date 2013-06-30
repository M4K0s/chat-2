
###
if !window.log

	window.log = (o) ->

		d = new Date()
		time = d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds()

		console.debug  time + " Pulse - " + o
###

class Node 

	constructor: (@socket = null) ->
		
	connect: (socketURL) -> 

		if typeof io is 'undefined' then return console.log 'ERROR::SERVER NOT RUN'

		@socket = io.connect socketURL
		
	addUser:	(uid = Math.random(0, 100), username =  Math.random(0, 100)) ->	

		@socket.emit 'adduser', uid, username

	addChannel:	(cid,channel) ->	

		@socket.emit 'addchannel', cid, channel

	addListeners: -> 

		@socket.on 'updateusers', (data) -> Chat.updateUsers(data)
			
		#listener, whenever the server emits 'updatechat', this updates the chat body
		@socket.on 'updatechat', (username, data) -> Chat.updateChat(username, data)

		#listener, whenever the server emits 'updatechannels', this updates the room the client is in
		@socket.on 'updatechannels', (channels, currentChannel) -> Chat.updateChannels(channels, currentChannel)

	addMessage: (data) ->

		@socket.emit 'sendchat', data
			
				

class Chat


	constructor: (options) ->

		@debug = true
		@channel = 'test'
		@cid = 2
		@adminUid = 1
		@Auth = null

		@vkApiID = 1906166
		@fbApiID = 279666928802339
		
		if options
			for property of options
					@[property] = options[property]

		
		@nodeInit()
		@init()


	nodeInit: -> 

		if typeof io is 'undefined' then  return console.log 'ERROR::SERVER NOT RUN'

		@Node = new Node()

		@Node.connect @socketURL
		@Node.addChannel( @cid, @channel )
		@Node.addListeners()

	init: ->

		
		$(document).on 'pagechange', (e) =>
			console.log 'pagechange'

		$(document).on 'pageinit', '#chat', (e) =>
			console.log 'chat - pageinit'
			
			@initElements()
			@bindElements()

			if !$$.browser.mobile
				$(window).resize () =>
					@resizeMessagesList()
					@resizeMessageContent()

			$(document).on 'orientationchange', (e) =>
				console.log 'orientationchange'
				@resizeMessagesList()
				@resizeMessageContent()

			$(document).on 'pageshow', '#chat', (e) =>
				console.log 'chat - pageshow'

				@resizeMessagesList()
				@resizeMessageContent()

				try
					@$messages.tinyscrollbar();
					@$messages.tinyscrollbar_update 'bottom'

				catch error
					@$messages .scrollTop @$messagesList.height()

				#if !@Auth
					#$.mobile.changePage '#auth'

		$(document).on 'pageshow', '#auth', (e) =>
			console.log 'auth - pageshow'

		$(document).on 'pageinit', '#auth', (e) =>
			console.log 'auth - pageinit'

			if @Auth
				$.mobile.changePage '#chat'
			else
				@loginInit()





	initElements: ->

		console.log 'chat - init elements'

		@$messages 				= $('#messages')
		@$messagesList 		= @$messages.find('.list')

		@$channels 				= $('#channels')
		@$channelsList 		= @$channels.find('.list')

		@$usersOnline			= $('#usersOnline')
		@$usersOnlineList 	= @$usersOnline.find('.list')

		@$sendBlock				= $('#sendBlock')
		@$messageInputField 	= @$sendBlock.find('input[type="text"]')
		@$messageSendBtn 		= @$sendBlock.find('input[type="button"]')

	bindElements: ->

		console.log 'chat - bind elements'

		@$messages.bind 'tap', () =>

			@hideKeyBoard()
			return false
	
		send = =>

			if !@Auth
				$.mobile.changePage '#auth'
				return

			content = @$messageInputField.val()

			return if $$.isEmpty content  

			@Node.addMessage {content: content}
			@$messageInputField.val('').focus()


		@$messageSendBtn.bind 'vclick', () ->

			send()
			return false

		$(window).keypress (event) ->

			if event.keyCode is 13 and ((event.keyCode is 13 and event.shiftKey) isnt true)

				send()
				return false

	resizeMessagesList: ->

		@$messages.height( window.innerHeight - $('div[data-role="header"]').height() - @$sendBlock.height() - 34)

	resizeMessageContent: ->

		console.log 'chat - windowresize'

		$content = @$messagesList.find('.content')

		$content.each ()->

			if $(@).width() > window.innerWidth - 90
				$(@).width(window.innerWidth - 90)
				$(@).addClass 'wrap'
			else
				###
				if $(@).hasClass 'wrap'
					$(@).removeAttr('style')
					$(@).removeClass 'wrap'
				###

	hideKeyBoard: ->

		$($.mobile.pageContainer).after('<input type="checkbox" id="focusable" style="height:0;margin-left:-200px;clear:both;" />')
		$('#focusable').focus()
		$('#focusable').remove()

	updateUsers: (data) ->

		@$usersOnlineList.empty()

		$.each data, (key, value) =>
	
			str = value.username
		
			@$usersOnlineList.append(str)

	updateChat: (type, data) ->

		if type is "SERVER"

			@$messagesList.append "<div class='system'>#{data}</div>"

		else

			avatar = data.avatar || "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAAErUlEQVR4Xu3YwStscRjG8d8QQnZEFkqyY6NE/n0rlOxkS1ZqrCiFe/udOtPcue6YJ889Gc93Vtz7eo/3eT/9zjl6/X7/V+FDAhMm0APMhElR1iQAGCBICQBGiotiwGBASgAwUlwUAwYDUgKAkeKiGDAYkBIAjBQXxYDBgJQAYKS4KAYMBqQEACPFRTFgMCAlABgpLooBgwEpAcBIcVEMGAxICQBGiotiwGBASgAwUlwUAwYDUgKAkeKiGDAYkBIAjBQXxYDBgJQAYKS4KAYMBqQEACPFRTFgMCAlABgpLooBgwEpAcBIcVEMGAxICQBGiotiwGBASgAwUlwUAwYDUgKAkeKiGDAYkBIAjBQXxYDBgJQAYKS4KAYMBqQEACPFRTFgMCAlABgpLooBgwEpAcBIcVEMGAxICQBGiotiwGBASgAwUlwUAwYDUgKAkeKiGDAYkBIAjBQXxYDBgJQAYKS4KAYMBqQEACPFRTFgMCAlABgpLooBgwEpgakH8/7+Xs7Ozsrz83M5OTkpi4uLfwRwd3dXbm5uyvr6etnf32/+r9/vl6urq1J/tn729vbKxsbGRMF1fb2JfqkOi6YazOvrazk9PS1vb2+l1+v9BaZd7tPT0wBM+zNLS0vl6OioXF5eNtjq13Nzc2Oj7/p6HTqY+FJTC2Z4eXXaj8BcX1+Xh4eHUmvX1taaE6Y9cba3t8vOzs7g+3rKzM/PNyfP8vJyA6j+/P39fXMCra6uDnC6rjfpqTbxNjsonGowFxcX5eDgYHBKDN+S2tvO1tZWub29/RRMC6ieOI+Pj+X4+Licn5+X9iSq6P7H9TrYsfUSUwumTeGjZ4r232ZmZsru7m5zarQnTHtqjJ4w7feT3naGn5m+cj3rNjto9iPBDN9K2tvMZ7ekFkzNvJ4y9YQaflAeB/Sr1+tgz7ZL/DgwCwsLzVtTfdAd/aysrJTNzc3mremjZ5j6TNHeyuoD8MvLy19vUKMn2levZ9tkR41+HJjR1+oWQHvCjHtLmp2dbbDVt67Dw8PmpKlfD79BffZarVzvs7eyjgxIl4kDM+7vMP96vhm+Nalgxl1P2tQ3KZ56MN8kx5hfAzAxq/YMChhPjjFdABOzas+ggPHkGNMFMDGr9gwKGE+OMV0AE7Nqz6CA8eQY0wUwMav2DAoYT44xXQATs2rPoIDx5BjTBTAxq/YMChhPjjFdABOzas+ggPHkGNMFMDGr9gwKGE+OMV0AE7Nqz6CA8eQY0wUwMav2DAoYT44xXQATs2rPoIDx5BjTBTAxq/YMChhPjjFdABOzas+ggPHkGNMFMDGr9gwKGE+OMV0AE7Nqz6CA8eQY0wUwMav2DAoYT44xXQATs2rPoIDx5BjTBTAxq/YMChhPjjFdABOzas+ggPHkGNMFMDGr9gwKGE+OMV0AE7Nqz6CA8eQY0wUwMav2DAoYT44xXQATs2rPoIDx5BjTBTAxq/YMChhPjjFdABOzas+ggPHkGNMFMDGr9gwKGE+OMV0AE7Nqz6CA8eQY0wUwMav2DAoYT44xXQATs2rPoIDx5BjTBTAxq/YMChhPjjFdABOzas+ggPHkGNMFMDGr9gz6G1HzSbXtC7t7AAAAAElFTkSuQmCC"
			
			@$messagesList.append """
				<div class='message'>
					<div class='avatar'><img src="#{avatar}" alt=""/></div>
					<div class='content'>#{data.content}</div>
				</div>
			"""

		try
			@$messages.tinyscrollbar_update 'bottom'

		catch error
			@$messages .scrollTop @$messagesList.height()

		@resizeMessageContent()

		#console.log data

	loginInit: ->


		if location.host.search('localhost') !=1

			@loginUser 'test'

			return


		VK.init {apiId: @vkApiID}
		FB.init {appId: @fbApiID, status: true, cookie: true,xfbml: true,oauth: true}

		$("#vk_auth").bind 'click', () =>

			VK.Auth.getLoginStatus (response) =>
				
				if response.session #Если залогинен в ВК сразу логинем в чат	

					@loginVK response.session.mid

				else #Если НЕТ запрашиваем инфу и логинем
			
					VK.Auth.login (response) =>
			
						if response.session  #Пользователь успешно авторизовался

							@loginVK response.session.mid

						#else #Пользователь нажал кнопку Отмена в окне авторизации

			return false


		$('#fb_auth').bind 'vclick', () =>
							
			FB.getLoginStatus (response) =>
			
				if response.status is 'connected'

					uid = response.authResponse.userID
					accessToken = response.authResponse.accessToken

					@loginFB uid
			
				else if response.status is 'not_authorized'
			
					FB.login (response) =>
			
						if response 
							if response.authResponse	

								@loginFB response.authResponse.userID	

							else 
								#unsuccessful auth
								#do things like notify user etc.	
				else
				#the user isn't even logged in to Facebook.

			return false
					
	loginVK: (uid) ->

		VK.Api.call 'users.get', {uids: uid, fields: 'uid, first_name, photo, bdate, sex'}, (r) =>
			if r.response					
				@loginUser 'vk', r.response[0]

	loginFB: (uid) ->

		FB.api '/'+ uid, (response)  =>
			if response					
				@loginUser 'fb', response

	loginUser: (type,data=null) ->

		if data? then console.log data

		if type is 'vk' and data?

			uid 			= data['uid']
			avatar		= data['photo']
			username 	= data['first_name']+' '+data['last_name']					
			uidVK	 		= data['uid']

			bdate 		= new Date().getFullYear() - data['bdate'].split('.')[2]
			bdate	 		= if !isNaN(bdate) then bdate else ""

			sex	 		= data['sex']

		if type is 'fb' and data?

			uid 		= data['id']
			avatar	= "https://graph.facebook.com/#{data['id']}/picture"
			username = data['first_name'] + ' ' + data['last_name']				
			uidFB	 	= data['id']
			sex	 	= data['gender']
			bdate		= ""

		if type is 'test'

			uid = 1
			username = 'testUsername'
			avatar = 'testAvatar'


		@Auth = 

			uid: uid
			username: username
			avatar: avatar
		
		@Node.addUser @Auth

		$.mobile.changePage '#chat'



	
		
	