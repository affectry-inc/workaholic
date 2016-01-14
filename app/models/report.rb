class Report < ActiveRecord::Base
  has_many :report_requests
  has_many :report_submissions, through: :report_requests

  validates :report_name, presence: true
  validates :beginning_date, presence: true
  validates :due_date, presence: true

  attr_accessor :target_user_ids
end
