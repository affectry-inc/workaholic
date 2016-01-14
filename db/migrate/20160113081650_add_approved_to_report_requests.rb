class AddApprovedToReportRequests < ActiveRecord::Migration
  def change
    add_column :report_requests, :approved, :boolean, default: false, after: :submitter_user_id
  end
end
