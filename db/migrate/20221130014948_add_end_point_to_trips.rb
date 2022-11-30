class AddEndPointToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :end_location, :string
  end
end
