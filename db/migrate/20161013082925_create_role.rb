class CreateRole < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :user_id
      t.integer :team_id
      t.string :role

      t.timestamps
    end
  end
end
