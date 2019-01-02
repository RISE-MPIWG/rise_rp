# == Schema Information
#
# Table name: content_units
#
#  id          :bigint(8)        not null, primary key
#  section_id  :bigint(8)
#  uuid        :uuid             not null
#  resource_id :bigint(8)
#  metadata    :jsonb
#  name        :string
#  content     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ContentUnit < ApplicationRecord
  default_scope { order(id: :asc) }
  include UuidFindable
  belongs_to :section, inverse_of: :content_units
  searchkick callbacks: :queue
end
