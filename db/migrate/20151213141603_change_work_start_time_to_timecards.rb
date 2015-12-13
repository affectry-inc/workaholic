class ChangeWorkStartTimeToTimecards < ActiveRecord::Migration
  def change
    change_column :timecards, :work_start_time, :timestampz
  end
end
