# == Schema Information
#
# Table name: special_holidays
#
#  id                      :integer          not null, primary key
#  title                   :string
#  description             :string
#  special_holiday_ctgr_id :integer
#  is_paid                 :boolean
#  is_as_attended          :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_special_holidays_on_special_holiday_ctgr_id  (special_holiday_ctgr_id)
#
# Foreign Keys
#
#  fk_rails_...  (special_holiday_ctgr_id => special_holiday_ctgrs.id)
#

class SpecialHoliday < ActiveRecord::Base
  belongs_to :special_holiday_ctgr
end
