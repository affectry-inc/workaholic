class CreateTimecards < ActiveRecord::Migration
  def change
    create_table :timecards do |t|
      t.date :biz_date
      t.integer :attn_ctgr
      t.time :work_start_time
      t.time :work_end_time
      t.time :rest_start_time
      t.time :rest_end_time

      t.timestamps null: false
    end
  end
end
