class ReportRequest < ActiveRecord::Base
  belongs_to :report
  has_many :report_submissions

  def ReportRequest.unsubmitted_count(user_id)
    report_requests = ReportRequest.where(submitter_user_id: user_id)
    unsubmitted_count = 0
    report_requests.each do |rr|
      unsubmitted_count += 1 if rr.report_submissions.count == 0
    end

    return unsubmitted_count
  end
end
