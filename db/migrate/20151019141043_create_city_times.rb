class CreateCityTimes < ActiveRecord::Migration
  def change
    create_table :city_times do |t|
      t.integer :hour
      t.integer :minute
      t.integer :final_destination_id
      t.timestamps null: false
    end
    add_reference :city_times, :destination, index: true, foreign_key: true
  end
end
