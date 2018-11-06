# == Schema Information
#
# Table name: resources
#
#  id            :bigint(8)        not null, primary key
#  uuid          :uuid             not null
#  collection_id :bigint(8)
#  name          :string
#  uri           :string
#  content       :jsonb
#  metadata      :jsonb
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ResourceSerializer < ApplicationSerializer
  attributes :uuid, :name
end
