class Distances < ActiveRecord::Migration
  def change
    create_table :city_distances do |t|
      t.integer :distance
      t.integer :final_destination_id
    end
    add_reference :city_distances, :destination, index: true, foreign_key: true
  end
end
