class AddStartPointToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :start_location, :string
  end
end
