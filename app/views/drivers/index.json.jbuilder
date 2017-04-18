json.array!(@drivers) do |driver|
  json.extract! driver, :id, :no, :name, :sex, :age, :tel, :team_id, :default_car_id
  json.url driver_url(driver, format: :json)
end
