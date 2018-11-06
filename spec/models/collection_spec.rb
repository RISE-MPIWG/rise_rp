# == Schema Information
#
# Table name: collections
#
#  id          :bigint(8)        not null, primary key
#  uuid        :uuid             not null
#  name        :string
#  metadata    :jsonb            not null
#  import_type :integer          default("script")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Collection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
