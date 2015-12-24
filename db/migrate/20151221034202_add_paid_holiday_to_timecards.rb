class AddPaidHolidayToTimecards < ActiveRecord::Migration
  def change
    add_column :timecards, :paid_holiday_hours, :integer, default: 0
  end
end
