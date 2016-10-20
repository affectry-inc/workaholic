# == Schema Information
#
# Table name: paid_holiday_usages
#
#  id              :integer          not null, primary key
#  paid_holiday_id :integer
#  user_id         :integer
#  usage_date      :date
#  days            :integer
#  hours           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class PaidHolidayUsageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
