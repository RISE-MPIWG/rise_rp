# == Schema Information
#
# Table name: collections
#
#  id                 :bigint(8)        not null, primary key
#  created_by_id      :integer
#  uuid               :uuid             not null
#  original_uuid      :string
#  organisation_id    :bigint(8)
#  name               :string
#  slug               :string
#  api_url            :string
#  metadata           :jsonb            not null
#  archived           :boolean          default(FALSE)
#  access_type        :integer          default("private_access")
#  api_mapping_module :integer          default("no_mapping_module")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  resources_url      :string
#

class Collection < ApplicationRecord
  paginates_per 50
  include UuidFindable
  default_scope { order(name: :asc) }

  has_many :resources, inverse_of: :collection, dependent: :delete_all
  has_many :sections, through: :resources
  has_many :content_units, through: :resources

  def to_s
    name
  end

  def resource_count
    resources.count
  end
end
