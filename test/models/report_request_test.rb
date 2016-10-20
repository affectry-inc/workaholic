# == Schema Information
#
# Table name: report_requests
#
#  id                :integer          not null, primary key
#  report_id         :integer
#  submitter_user_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  approved          :boolean          default(FALSE)
#

require 'test_helper'

class ReportRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
