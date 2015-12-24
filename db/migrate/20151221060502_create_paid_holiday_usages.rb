class CreatePaidHolidayUsages < ActiveRecord::Migration
  def change
    create_table :paid_holiday_usages do |t|
      t.integer :paid_holiday_id
      t.integer :user_id
      t.date :usage_date
      t.integer :days
      t.integer :hours

      t.timestamps null: false
    end
  end
end
