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

class Collection < ApplicationRecord
  paginates_per 50
  include UuidFindable
  default_scope { order(name: :asc) }

  has_many :resources, inverse_of: :collection, dependent: :delete_all
  has_many :sections, through: :resources
  has_many :content_units, through: :resources

  IMPORT_TYPES = { script: 0, folder: 1, views: 2 }.freeze

  enum import_type: IMPORT_TYPES

  def to_s
    name
  end

  def check_and_parse!
    case import_type.to_sym
    when :script
    when :folder
      section_ids = self.sections.map(&:id)
      ContentUnit.where(section_id: section_ids).delete_all
      Section.where(id: section_ids).delete_all
      self.resources.delete_all
      self.reload
      cfp = CollectionFolderParser.new(self)
      cfp.create_hierarchy
    when :views
    end
  end

  def resource_count
    resources.count
  end
end
