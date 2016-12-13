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
    @geocode_search ||= HTTParty.get(GOOGLE_GEOCODE_URL, query: geocode_query)
  end

  def place_search
    @place_seach ||= HTTParty.get(GOOGLE_PLACE_URL, query: place_query)
  end

  def distance_search(other_destinations)
    @distance_search ||= HTTParty.get(GOOGLE_DISTANCE_URL,
                                      query: distance_query(other_destinations))
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
    return nil if place_search['result']['photos'].nil?
    place_search['result']['photos'].first['photo_reference']
  end

  def photo_url
    return if photo_reference.nil?
    GOOGLE_IMAGE_URL + '?photoreference=' + photo_reference + '&key=' + API_KEY + '&maxwidth=540'
  end

  def distance_results(other_destinations)
    distance_search(other_destinations)['rows'][0]['elements']
  end

  def geocode_query
    { address: city + ',' + state,
      key: API_KEY }
  end

  def place_query
    { placeid: place_id,
      key: API_KEY }
  end

  def distance_query(other_destinations)
    { key: API_KEY,
      origins: city + ',' + state,
      destinations: other_destinations.map { |d| d.city + ',' + d.state }.join('|') }
  end
end
