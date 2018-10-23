# == Schema Information
#
# Table name: resources
#
#  id              :bigint(8)        not null, primary key
#  created_by_id   :integer
#  uuid            :uuid             not null
#  original_uuid   :string           default("")
#  organisation_id :bigint(8)
#  collection_id   :bigint(8)
#  name            :string
#  uri             :string
#  contents        :jsonb
#  metadata        :jsonb
#  archived        :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Resource < ApplicationRecord

  include UuidFindable

  belongs_to :collection, inverse_of: :resources

  has_many :sections, inverse_of: :resource
  has_many :content_units, through: :sections

  def to_s
    name
  end

  def full_name
    "#{collection.name} > #{name}"
  end

  def collection_uuid
    collection.uuid
  end
end
