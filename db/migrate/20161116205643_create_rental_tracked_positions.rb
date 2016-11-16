class CreateRentalTrackedPositions < ActiveRecord::Migration[5.0]
  def change
    create_table :rental_tracked_positions do |t|
      t.datetime :tracked_at
      t.float :latitude
      t.float :longitude

      t.references :rental

      t.timestamps
    end
  end
end
