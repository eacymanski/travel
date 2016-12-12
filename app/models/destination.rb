class Destination < ActiveRecord::Base
  require 'net/http'
  has_many :city_distances
  has_many :destinations, through: :city_distances, source: :final_destination, :dependent => :destroy

  has_many :city_times
  has_many :destinations, through: :city_times, source: :final_destination

  belongs_to :trip

  STATES = Array[ ["AK", "Alaska"], 
                    ["AL", "Alabama"], 
                    ["AR", "Arkansas"], 
                    ["AS", "American Samoa"], 
                    ["AZ", "Arizona"], 
                    ["CA", "California"], 
                    ["CO", "Colorado"], 
                    ["CT", "Connecticut"], 
                    ["DC", "District of Columbia"], 
                    ["DE", "Delaware"], 
                    ["FL", "Florida"], 
                    ["GA", "Georgia"], 
                    ["GU", "Guam"], 
                    ["HI", "Hawaii"], 
                    ["IA", "Iowa"], 
                    ["ID", "Idaho"], 
                    ["IL", "Illinois"], 
                    ["IN", "Indiana"], 
                    ["KS", "Kansas"], 
                    ["KY", "Kentucky"], 
                    ["LA", "Louisiana"], 
                    ["MA", "Massachusetts"], 
                    ["MD", "Maryland"], 
                    ["ME", "Maine"], 
                    ["MI", "Michigan"], 
                    ["MN", "Minnesota"], 
                    ["MO", "Missouri"], 
                    ["MS", "Mississippi"], 
                    ["MT", "Montana"], 
                    ["NC", "North Carolina"], 
                    ["ND", "North Dakota"], 
                    ["NE", "Nebraska"], 
                    ["NH", "New Hampshire"], 
                    ["NJ", "New Jersey"], 
                    ["NM", "New Mexico"], 
                    ["NV", "Nevada"], 
                    ["NY", "New York"], 
                    ["OH", "Ohio"], 
                    ["OK", "Oklahoma"], 
                    ["OR", "Oregon"], 
                    ["PA", "Pennsylvania"], 
                    ["PR", "Puerto Rico"], 
                    ["RI", "Rhode Island"], 
                    ["SC", "South Carolina"], 
                    ["SD", "South Dakota"], 
                    ["TN", "Tennessee"], 
                    ["TX", "Texas"], 
                    ["UT", "Utah"], 
                    ["VA", "Virginia"], 
                    ["VI", "Virgin Islands"], 
                    ["VT", "Vermont"], 
                    ["WA", "Washington"], 
                    ["WI", "Wisconsin"], 
                    ["WV", "West Virginia"], 
                    ["WY", "Wyoming"] ]
  
    def updateLatLong
      uri = "https://maps.googleapis.com/maps/api/geocode/json?address="+city+",+"+state+'&key=AIzaSyA8Fri1EieFp_cOgtin8sb3MlChwG_Y2cc'
      url=URI.parse(uri)
      req = Net::HTTP::Get.new(url.to_s)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      res=ActiveSupport::JSON.decode(http.request(req).body)
      self.latitude=res['results'].first['geometry']['location']['lat']
      self.longitude=res['results'].first['geometry']['location']['lng']
      save
    end
  
end
