class CreateTimecards < ActiveRecord::Migration
  def change
    create_table :timecards do |t|
      t.date :biz_date
      t.integer :attn_ctgr
      t.timestamp :work_start_time
      t.timestamp :work_end_time
      t.timestamp :rest_start_time
      t.timestamp :rest_end_time

      t.timestamps null: false
    end
  end
end
