# == Schema Information
#
# Table name: approvers
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  approver_user_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Approver < ActiveRecord::Base
end
