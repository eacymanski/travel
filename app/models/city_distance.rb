class CityDistance < ActiveRecord::Base
  belongs_to :destination
  belongs_to :final_destination, class_name: :Destination
  
end