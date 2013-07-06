class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :firstname
      t.string :lastname
      t.integer :rank
      t.integer :wins
      t.integer :losses
      t.integer :atp_points

      t.timestamps
    end
  end
end
