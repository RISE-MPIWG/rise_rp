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

FactoryBot.define do
  factory :collection do
    
  end
end
