# == Schema Information
#
# Table name: sections
#
#  id                   :bigint(8)        not null, primary key
#  resource_id          :bigint(8)
#  uuid                 :uuid             not null
#  name                 :string
#  uri                  :string
#  original_parent_uuid :string
#  original_uuid        :string
#  metadata             :jsonb
#  ancestry             :string
#  is_leaf              :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class SectionSerializer < ApplicationSerializer
  attributes :uuid, :name, :parent_uuid, :content_unit_count
end
