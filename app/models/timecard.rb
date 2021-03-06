# == Schema Information
#
# Table name: timecards
#
#  id                 :integer          not null, primary key
#  biz_date           :date
#  attn_ctgr          :integer
#  work_start_time    :datetime
#  work_end_time      :datetime
#  rest_start_time    :datetime
#  rest_end_time      :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  wf_status          :integer          default(0)
#  paid_holiday_hours :integer          default(0)
#

class Timecard < ActiveRecord::Base
  VALID_TIME_REGEX = /\A(\d{1,2}):(\d{2})\z/
  validates :work_start_time, presence: true
  validates :work_end_time, presence: true
  validates :rest_start_time, presence: true
  validates :rest_end_time, presence: true
  validates_numericality_of :paid_holiday_hours, less_than: 9
  validate :check_time_relation
  validate :check_paid_holiday
  validate :check_holiday_work

  attr_accessor :is_new, :is_editable, :attn_ctgr_disp, :holiday_ctgr, :wf_status_ctgr_disp, 
                :remaining_paid_days, :remaining_paid_hours
  # holiday_ctgr 0:non-holiday 1:holiday 2:Sadurday 3:Sunday

  def check_time_relation
    return if self.wf_status == 0

    unless self.work_start_time <= self.rest_start_time && self.rest_start_time <= self.rest_end_time && self.rest_end_time <= self.work_end_time
      errors[:base] << "時間の前後関係が不正です"
    end
  end

  def check_paid_holiday
    self.paid_holiday_hours = 0 if self.attn_ctgr != 0

    return if self.attn_ctgr != 2 && self.paid_holiday_hours == 0

    if self.attn_ctgr == 2 && self.remaining_paid_days.to_i == 0
      errors[:attn_ctgr] << "残有給休暇日数が足りません"
    end

    if self.paid_holiday_hours && (self.remaining_paid_hours.to_i <  self.paid_holiday_hours)
      errors[:paid_holiday_hours] << "残有給休暇時間が足りません"
    end
  end

  def check_holiday_work
    if Timecard.get_holiday_ctgr(self.biz_date) != 0
      if self.attn_ctgr == 1 || self.attn_ctgr == 2
        self.attn_ctgr = 9
      end
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

  def self.get_holiday_ctgr(date)
    if HolidayJapan.check(date)
      return 1
    elsif date.wday == 0
      return 3
    elsif date.wday == 6
      return 2
    else
      return 0
    end
  end
end
