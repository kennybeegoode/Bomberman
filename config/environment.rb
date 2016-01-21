require 'pusher'

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

Pusher.app_id = 'insert id here'
Pusher.key = 'insert pusher key here'
Pusher.secret = 'insert pusher secret here'