json.array!(@bombermen) do |bomberman|
  json.extract! bomberman, :id, :lobbyid
  json.url bomberman_url(bomberman, format: :json)
end
