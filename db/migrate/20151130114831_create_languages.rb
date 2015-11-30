class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.integer :lang_id
      t.string :name

      t.timestamps null: false
    end
  end
end
