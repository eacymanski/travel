json.array!(@destinations) do |destination|
  json.extract! destination, :id, :city, :state, :picture
  json.url destination_url(destination, format: :json)
end
