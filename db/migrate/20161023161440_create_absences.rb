class CreateAbsences < ActiveRecord::Migration
  def change
    create_table :absences do |t|
      t.belongs_to :timecard, index: true, foreign_key: true
      t.integer :absence_type
      t.belongs_to :extra_holiday, index: true, foreign_key: true
      t.belongs_to :special_holiday, index: true, foreign_key: true
      t.boolean :is_hourly
      t.timestamp :start_time
      t.timestamp :end_time
      t.string :comment
      t.boolean :is_paid
      t.boolean :is_as_attended

      t.timestamps null: false
    end
  end
end
