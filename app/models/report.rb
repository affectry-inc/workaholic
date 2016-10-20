# == Schema Information
#
# Table name: reports
#
#  id               :integer          not null, primary key
#  receiver_user_id :integer
#  report_name      :string
#  beginning_date   :date
#  due_date         :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Report < ActiveRecord::Base
  has_many :report_requests, dependent: :destroy
  has_many :report_submissions, through: :report_requests

  validates :report_name, presence: true
  validates :beginning_date, presence: true
  validates :due_date, presence: true

  attr_accessor :target_user_ids

  def Report.reports_of(user_id, date = Date.today)
    Report.joins(:report_requests).where('beginning_date < ?', date)
                                  .where(report_requests: {submitter_user_id: user_id})
  end
end
