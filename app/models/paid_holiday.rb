class PaidHoliday < ActiveRecord::Base
  has_many :paid_holiday_usages
end
