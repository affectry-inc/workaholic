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

require 'test_helper'

class TimecardTest < ActiveSupport::TestCase

  def setup
  end
end
