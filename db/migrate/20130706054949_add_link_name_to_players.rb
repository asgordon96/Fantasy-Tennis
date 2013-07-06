class AddLinkNameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :link_name, :string
  end
end
