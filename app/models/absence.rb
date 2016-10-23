# == Schema Information
#
# Table name: absences
#
#  id                 :integer          not null, primary key
#  timecard_id        :integer
#  absence_type       :integer
#  extra_holiday_id   :integer
#  special_holiday_id :integer
#  is_hourly          :boolean
#  start_time         :datetime
#  end_time           :datetime
#  comment            :string
#  is_paid            :boolean
#  is_as_attended     :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_absences_on_extra_holiday_id    (extra_holiday_id)
#  index_absences_on_special_holiday_id  (special_holiday_id)
#  index_absences_on_timecard_id         (timecard_id)
#

class Absence < ActiveRecord::Base
  belongs_to :timecard
  belongs_to :extra_holiday
  belongs_to :special_holiday
end
