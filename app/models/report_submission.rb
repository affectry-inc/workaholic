# == Schema Information
#
# Table name: report_submissions
#
#  id                :integer          not null, primary key
#  report_request_id :integer
#  file_name         :string
#  submission_time   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ReportSubmission < ActiveRecord::Base
  belongs_to :report_request
end
