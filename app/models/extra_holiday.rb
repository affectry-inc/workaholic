# == Schema Information
#
# Table name: extra_holidays
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :string
#  is_hourly           :boolean
#  is_comment_required :boolean
#  is_paid             :boolean
#  is_as_attended      :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ExtraHoliday < ActiveRecord::Base
end
