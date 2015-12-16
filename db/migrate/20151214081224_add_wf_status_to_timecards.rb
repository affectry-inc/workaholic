class AddWfStatusToTimecards < ActiveRecord::Migration
  def change
    add_column :timecards, :wf_status, :integer, default: 0
  end
end
