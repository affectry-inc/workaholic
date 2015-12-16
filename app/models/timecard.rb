class Timecard < ActiveRecord::Base
  VALID_TIME_REGEX = /\A(\d{1,2}):(\d{2})\z/
  validates :work_start_time, presence: true
  validates :work_end_time, presence: true
  validates :rest_start_time, presence: true
  validates :rest_end_time, presence: true
  validate :check_time_relation

  attr_accessor :is_new, :is_editable, :attn_ctgr_disp, :holiday_ctgr, :is_disp_times, :wf_status_ctgr_disp
  # holiday_ctgr 0:non-holiday 1:holiday 2:Sadurday 3:Sunday

  def check_time_relation
    return if self.wf_status == 0

    unless self.work_start_time <= self.rest_start_time && self.rest_start_time <= self.rest_end_time && self.rest_end_time <= self.work_end_time
      errors[:base] << "時間の前後関係が不正です"
    end
  end

  def modify_times_date
    self.work_start_time = Time.zone.local(biz_date.year, biz_date.month, biz_date.day,
                                           self.work_start_time.hour, self.work_start_time.min, 0)
    self.work_end_time = Time.zone.local(biz_date.year, biz_date.month, biz_date.day,
                                           self.work_end_time.hour, self.work_end_time.min, 0)
    self.rest_start_time = Time.zone.local(biz_date.year, biz_date.month, biz_date.day,
                                           self.rest_start_time.hour, self.rest_start_time.min, 0)
    self.rest_end_time = Time.zone.local(biz_date.year, biz_date.month, biz_date.day,
                                           self.rest_end_time.hour, self.rest_end_time.min, 0)
  end

end
