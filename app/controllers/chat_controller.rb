class ChatController < ApplicationController

	require 'pusher'
	
	Pusher.app_id = 'insert id here'
	Pusher.key = 'insert pusher key here'
	Pusher.secret = 'insert pusher secret here'   

	def hello_world
			Pusher.trigger('test_channel', 'my_event', {:message => 'hello world'})
	end

	helper_method :hello_world


	def index
		@user = current_user.email.gsub(/"/ ,"")
	end

	def initialize_session

		controller_store[:message_count] = 0
	end

	def send_msg
			# msg = params[:message]
		  flash.now[:notice] = 'Message sent!'

		# new_message = {:message => 'this is a message'}
		# send_message :send_msg, new_message
	end

	def user_connected
		p 'user_connected'
		send_message :user_info, {:user => current_user.screen_name}
	end

	def incoming_message
		broadcast_message :new_message, {:user => current_user.screen_name,:text => message[:text]}
	end
	
end
