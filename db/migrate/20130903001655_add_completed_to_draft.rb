class AddCompletedToDraft < ActiveRecord::Migration
  def change
    add_column :drafts, :completed, :boolean
  end
end
