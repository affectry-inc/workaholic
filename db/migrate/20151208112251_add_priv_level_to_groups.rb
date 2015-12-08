class AddPrivLevelToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :priv_level, :integer
  end
end
