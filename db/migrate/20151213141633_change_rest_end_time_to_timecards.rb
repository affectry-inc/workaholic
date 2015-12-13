class ChangeRestEndTimeToTimecards < ActiveRecord::Migration
  def change
    change_column :timecards, :rest_end_time, :timestamp
  end
end
