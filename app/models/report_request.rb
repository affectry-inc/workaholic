# == Schema Information
#
# Table name: report_requests
#
#  id                :integer          not null, primary key
#  report_id         :integer
#  submitter_user_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  approved          :boolean          default(FALSE)
#

class ReportRequest < ActiveRecord::Base
  belongs_to :report
  has_many :report_submissions

  def ReportRequest.unsubmitted_count(user_id)
    unsubmitted_count = 0
    reports = Report.reports_of(user_id)
    reports.each do |r|
      rr = r.report_requests.find_by(submitter_user_id: user_id)
      unsubmitted_count += 1 if rr.report_submissions.count == 0
    end

    return unsubmitted_count
  end
end
