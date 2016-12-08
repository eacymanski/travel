class AddTripReferenceToDestination < ActiveRecord::Migration
  def change
    add_reference :destinations, :trip, foreign_key: true
  end
end
