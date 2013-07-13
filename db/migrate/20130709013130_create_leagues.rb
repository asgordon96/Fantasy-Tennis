class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.datetime :draft_time

      t.timestamps
    end
  end
end
