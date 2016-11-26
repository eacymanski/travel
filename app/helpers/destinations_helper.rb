module DestinationsHelper
  def getDistances(destination)
    if Destination.count>1
      i=0
      num=Destination.count
      destination.city_distances.clear
      while i<num
       uri = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins='+destination.city+'+'+destination.state+'&destinations='
        j=0
        hold =i
        while j<40 && i <num
          des = Destination.all[i]
          uri=uri+des.city+'+'+des.state if des!=destination
          uri=uri+'|' if i!=num-1 || j!=39
          j+=1
          i+=1
        end
        uri=uri+'&key=AIzaSyAfTrqJtxTAB-8MIEnIt22pi2Kfp37Xxps'
        puts uri
        url=URI.parse(URI.encode(uri))
        req = Net::HTTP::Get.new(url.to_s)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        res=ActiveSupport::JSON.decode(http.request(req).body)
        distances = res['rows'][0]['elements']

        count =0
        j=0
        i=hold
        while j<40 && i<num
          des = Destination.all[i]
          if des!=destination
            if distances[count]['status']!="ZERO_RESULTS"
              km=distances[count]['distance']['value']
              destination.city_distances.create(final_destination: des, distance: km)
              des.city_distances.create(final_destination: destination, distance: km)
            end
            count+=1
            j+=1
          end
          i+=1
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
  
end
