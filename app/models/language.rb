# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  lang_id    :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Language < ActiveRecord::Base
end
