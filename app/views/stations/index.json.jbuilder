json.array!(@stations) do |station|
  json.extract! station, :id, :no, :name, :address, :tel, :team_id
  json.url station_url(station, format: :json)
end
