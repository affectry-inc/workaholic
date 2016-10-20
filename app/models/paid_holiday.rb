# == Schema Information
#
# Table name: paid_holidays
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  days            :integer
#  hours           :integer
#  beginning_date  :date
#  expiration_date :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class PaidHoliday < ActiveRecord::Base
  has_many :paid_holiday_usages
end
