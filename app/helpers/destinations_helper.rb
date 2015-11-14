module DestinationsHelper
  def getDistances(destination)
    other_destinations = Destination.where('id != ?', destination.id)
    uri = 'https://maps.googleapis.com/maps/api/distancematrix/json'
    params = {
      origins: destination.city+'+'+destination.state,
      destinations: other_destinations.map { |d| d.city+'+'+d.state }.join('|'),
      key: 'AIzaSyAfTrqJtxTAB-8MIEnIt22pi2Kfp37Xxps',
    }
    raw_result = HTTParty.get(uri, query: params).body
    results = JSON.parse(raw_result)['rows'][0]['elements']

    results.each_with_index do |result, i|
      next if result['status'] == "ZERO_RESULTS"

      destination.city_distances.create(
        final_destination: other_destinations[i],
        distance: result['distance']['value']
      )

      other_destinations[i].city_distances.create(
        final_destination: destination,
        distance: result['distance']['value']
      )
    end
  end
  
  def removeDistance(destination)
    Destination.all.each do |des|
      if des!=destination
        to_destroy = des.city_distances.where(final_destination: destination)
        to_destroy.destroy_all
      end
    end
  end
  
  
end
