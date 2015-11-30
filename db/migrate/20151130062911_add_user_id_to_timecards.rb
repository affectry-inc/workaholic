class AddUserIdToTimecards < ActiveRecord::Migration
  def change
    add_column :timecards, :user_id, :integer
  end
end
