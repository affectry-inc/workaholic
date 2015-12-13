class ChangeWorkStartTimeToTimecards < ActiveRecord::Migration
  def change
    change_column :timecards, :work_start_time, :timestamp_with_tz
  end
end
