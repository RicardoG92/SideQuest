class AddGeocoordinateToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :start_geolocation, :json
    add_column :trips, :end_geolocation, :json
  end
end
