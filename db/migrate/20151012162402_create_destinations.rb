class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :city
      t.string :state
      t.string :picture

      t.timestamps null: false
    end
  end
end
