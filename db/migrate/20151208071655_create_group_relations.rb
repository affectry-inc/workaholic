class CreateGroupRelations < ActiveRecord::Migration
  def change
    create_table :group_relations do |t|
      t.integer :applicant_group_id
      t.integer :approver_group_id

      t.timestamps null: false
    end
  end
end
