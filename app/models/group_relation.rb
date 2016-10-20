# == Schema Information
#
# Table name: group_relations
#
#  id                 :integer          not null, primary key
#  applicant_group_id :integer
#  approver_group_id  :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class GroupRelation < ActiveRecord::Base
end
