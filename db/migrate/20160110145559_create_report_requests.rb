class CreateReportRequests < ActiveRecord::Migration
  def change
    create_table :report_requests do |t|
      t.integer :report_id
      t.integer :submitter_user_id

      t.timestamps null: false
    end
  end
end
