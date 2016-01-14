class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :receiver_user_id
      t.string :report_name
      t.date :beginning_date
      t.date :due_date

      t.timestamps null: false
    end
  end
end
