class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :no
      t.string :car_number
      t.string :car_type
      t.integer :team_id
      t.integer :default_driver_id

      t.timestamps
    end

    add_index :cars, :car_number, :unique => true
  end
end
