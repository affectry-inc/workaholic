class CreateSpecialHolidays < ActiveRecord::Migration
  def change
    create_table :special_holidays do |t|
      t.string :title
      t.string :description
      t.belongs_to :special_holiday_ctgr, index: true, foreign_key: true
      t.boolean :is_paid
      t.boolean :is_as_attended

      t.timestamps null: false
    end
  end
end
