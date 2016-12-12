class GoogleApi
  API_KEY = 'AIzaSyDxngRSH9l184B05psCbdacV5iB91XaYpg'.freeze
  GOOGLE_GEOCODE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze
  GOOGLE_PLACE_URL = 'https://maps.googleapis.com/maps/api/place/details/json'.freeze
  GOOGLE_IMAGE_URL = 'https://maps.googleapis.com/maps/api/place/photo'.freeze
  GOOGLE_DISTANCE_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json'.freeze

  def initialize(city, state)
    @city = city
    @state = state
  end

  attr_reader :city, :state

  def geocode_search
    @geocode_search ||= HTTParty.get(GOOGLE_GEOCODE_URL, query: { address: city + ',' + state, key: API_KEY })
  end

  def place_search
    @place_seach ||= HTTParty.get(GOOGLE_PLACE_URL, query: { placeid: place_id, key: API_KEY })
  end

  def latitude
    geocode_result['geometry']['location']['lat']
  end

  def longitude
    geocode_result['geometry']['location']['lng']
  end

  def place_id
    geocode_result['place_id']
  end

  def geocode_result
    geocode_search['results'].first
  end

  def photo_reference
    place_search['result']['photos'].first['photo_reference']
  end

  def photo_url
    GOOGLE_IMAGE_URL + '?photoreference=' + photo_reference + '&key=' + API_KEY + '&maxwidth=540'
  end

  def get_distances
    distance_search
  end

  def distance_search(desination_id)
    @distance_search ||= HTTParty.get(GOOGLE_DISTANCE_URL, query: distance_query(desination_id))
  end

  def distance_query(destination_id)
    other_destinations = Destination.where('id !=?', destination_id)
    { key: API_KEY,
      origins: city+','+state,
      destinations: other_destinations.map { |d| d.city + ',' + d.state }.join('|')
    }
  end
end
