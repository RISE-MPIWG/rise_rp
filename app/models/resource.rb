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
