class Timecard < ActiveRecord::Base
  VALID_TIME_REGEX = /\A(\d{1,2}):(\d{2})\z/
  validates :work_start_time, presence: true, timeliness: { format: '%H:%M' }
  validates :work_end_time, presence: true, timeliness: { format: '%H:%M' }
  validates :rest_start_time, presence: true, timeliness: { format: '%H:%M' }
  validates :rest_end_time, presence: true, timeliness: { format: '%H:%M' }
  validate :check_time_relation

  attr_accessor :is_new, :is_editable, :attn_ctgr_disp, :holiday_ctgr, :is_disp_times
  # holiday_ctgr 0:non-holiday 1:holiday 2:Sadurday 3:Sunday

  def check_time_relation
    unless self.work_start_time <= self.rest_start_time && self.rest_start_time <= self.rest_end_time && self.rest_end_time <= self.work_end_time
      errors[:base] << "時間の前後関係が不正です"
    end
  end
end
