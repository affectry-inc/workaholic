class CreateExtraHolidays < ActiveRecord::Migration
  def change
    create_table :extra_holidays do |t|
      t.string :title
      t.string :description
      t.boolean :is_hourly
      t.boolean :is_comment_required
      t.boolean :is_paid
      t.boolean :is_as_attended

      t.timestamps null: false
    end
  end
end
