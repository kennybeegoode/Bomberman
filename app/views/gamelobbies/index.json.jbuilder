json.array!(@gamelobbies) do |gamelobby|
  json.extract! gamelobby, :id, :lobbyid, :lobbyname, :public, :gamestarted, :usercount, :userlist
  json.url gamelobby_url(gamelobby, format: :json)
end
