class ChangeWorkEndTimeToTimecards < ActiveRecord::Migration
  def change
    change_column :timecards, :work_end_time, :timestamp_with_tz
  end
end
