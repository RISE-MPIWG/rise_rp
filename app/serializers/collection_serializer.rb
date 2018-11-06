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

class CollectionSerializer < ApplicationSerializer
  attributes :uuid, :name
end
