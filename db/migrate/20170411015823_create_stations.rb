class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :no
      t.string :name
      t.string :address
      t.string :tel
      t.integer :team_id

      t.timestamps
    end
    
    add_index :stations, :name, :unique => true
  end
end
