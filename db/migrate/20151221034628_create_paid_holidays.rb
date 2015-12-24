class CreatePaidHolidays < ActiveRecord::Migration
  def change
    create_table :paid_holidays do |t|
      t.integer :user_id
      t.integer :days
      t.integer :hours
      t.date :beginning_date
      t.date :expiration_date

      t.timestamps null: false
    end
  end
end
