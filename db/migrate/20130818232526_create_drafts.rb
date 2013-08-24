class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.string :order
      t.string :player
      t.integer :bid
      t.integer :team
      t.integer :nominator

      t.timestamps
    end
  end
end
