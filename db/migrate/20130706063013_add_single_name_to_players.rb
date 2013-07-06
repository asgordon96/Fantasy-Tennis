class AddSingleNameToPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :firstname
    remove_column :players, :lastname
    add_column :players, :name, :string
  end
end
