class CreateReportSubmissions < ActiveRecord::Migration
  def change
    create_table :report_submissions do |t|
      t.integer :report_request_id
      t.string :file_name
      t.timestamp :submission_time

      t.timestamps null: false
    end
  end
end
