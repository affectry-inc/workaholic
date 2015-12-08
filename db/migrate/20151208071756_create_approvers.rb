class CreateApprovers < ActiveRecord::Migration
  def change
    create_table :approvers do |t|
      t.integer :user_id
      t.integer :approver_user_id

      t.timestamps null: false
    end
  end
end
