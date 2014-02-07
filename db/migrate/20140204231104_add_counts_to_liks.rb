class AddCountsToLiks < ActiveRecord::Migration
  def up
    add_column :links, :count, :integer, :default => 0
  end

  def down
    remove_column :links, :count
  end
end
