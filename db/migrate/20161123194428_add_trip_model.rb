class AddTripModel < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :title
    end
  end
end
