json.array!(@gamechats) do |gamechat|
  json.extract! gamechat, :id, :lobbyid, :message
  json.url gamechat_url(gamechat, format: :json)
end
