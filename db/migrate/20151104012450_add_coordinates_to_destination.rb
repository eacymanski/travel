class AddCoordinatesToDestination < ActiveRecord::Migration
  def change
    add_column :destinations, :latitude, :decimal
    add_column :destinations, :longitude, :decimal
  end
end
