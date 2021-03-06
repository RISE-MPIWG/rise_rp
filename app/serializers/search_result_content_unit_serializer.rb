class SearchResultContentUnitSerializer < ApplicationSerializer
  attributes :collection_uuid, :resource_uuid, :section_uuid, :uuid, :context

  def collection_uuid
    object.section.resource.collection.uuid
  end

  def resource_uuid
    object.section.resource.uuid
  end

  def section_uuid
    object.section.uuid
  end

  def context
    highlight[:content].html_safe
  end
end

