class ChangeRestStartTimeToTimecards < ActiveRecord::Migration
  def change
    change_column :timecards, :rest_start_time, :timestamp
  end
end