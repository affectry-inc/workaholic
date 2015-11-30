class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :ctgr_id
      t.integer :lang_id
      t.integer :val
      t.string :name

      t.timestamps null: false
    end
  end
end
