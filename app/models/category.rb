# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  ctgr_id    :integer
#  lang_id    :integer
#  val        :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
end
