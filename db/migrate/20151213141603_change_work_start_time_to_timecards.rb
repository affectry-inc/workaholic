class ChangeWorkStartTimeToTimecards < ActiveRecord::Migration
  def change
    change_column :timecards, :work_start_time, :timestamp
  end
end
