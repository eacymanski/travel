ActiveRecord::Schema.define(version: 20161123200747) do

  create_table 'city_distances', force: :cascade do |t|
    t.integer 'distance'
    t.integer 'final_destination_id'
    t.integer 'destination_id'
  end

  add_index 'city_distances', ['destination_id'], name: 'index_city_distances_on_destination_id'

  create_table 'city_times', force: :cascade do |t|
    t.integer  'hour'
    t.integer  'minute'
    t.integer  'final_destination_id'
    t.datetime 'created_at',           null: false
    t.datetime 'updated_at',           null: false
    t.integer  'destination_id'
  end

  add_index 'city_times', ['destination_id'], name: 'index_city_times_on_destination_id'

  create_table 'destinations', force: :cascade do |t|
    t.string   'city'
    t.string   'state'
    t.string   'picture'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.decimal  'latitude'
    t.decimal  'longitude'
    t.integer  'trip_id'
  end

  create_table 'trips', force: :cascade do |t|
    t.string 'title'
  end
end
