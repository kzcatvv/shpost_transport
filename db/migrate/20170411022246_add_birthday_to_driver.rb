class AddBirthdayToDriver < ActiveRecord::Migration
  def change
    add_column :drivers, :birthday, :date
  end
end
