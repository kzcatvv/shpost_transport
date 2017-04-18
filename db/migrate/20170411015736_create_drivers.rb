class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :no
      t.string :name
      t.string :sex
      t.integer :work_age, :default => 0
      t.string :tel
      t.integer :team_id
      t.integer :default_car_id

      t.timestamps
    end

  end
end
