class AddDefTimesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :use_def_times, :boolean, default: false
    add_column :users, :def_work_start_time, :time
    add_column :users, :def_work_end_time, :time
    add_column :users, :def_rest_start_time, :time
    add_column :users, :def_rest_end_time, :time
  end
end
