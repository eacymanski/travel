module DestinationsHelper
  def getDistances(destination)
    if Destination.count>1
      destination.city_distances.clear
      uri = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins='+destination.city+'+'+destination.state+'&destinations='
      Destination.all.each do |des|
        uri=uri+des.city+'+'+des.state if des!=destination
        uri=uri+'|' if des!=Destination.last
      end
      uri=uri+'&key=AIzaSyAfTrqJtxTAB-8MIEnIt22pi2Kfp37Xxps'
      puts uri
      url=URI.parse(uri)
      req = Net::HTTP::Get.new(url.to_s)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      res=ActiveSupport::JSON.decode(http.request(req).body)
      distances = res['rows'][0]['elements']
      puts distances
      count =0
        Destination.all.each do |des|
          if des!=destination
            if distances[count]['status']!="ZERO_RESULTS"
            
              km=distances[count]['distance']['value']
              destination.city_distances.create(final_destination: des, distance: km)
              des.city_distances.create(final_destination: destination, distance: km)
            end
            count+=1
          end
        end
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
  
  def latLong
     positions=[ {lat: 25.363, lng: -101.044}, {lat: 30.363, lng: -91.044}]
   end
end
