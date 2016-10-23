class CreateSpecialHolidayCtgrs < ActiveRecord::Migration
  def change
    create_table :special_holiday_ctgrs do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
