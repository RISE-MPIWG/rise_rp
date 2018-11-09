require 'fileutils'
require 'csv'
require 'json'

namespace :import do  
  desc 'import ADAB corpus'
  task adab: :environment do
    col = Collection.find_or_create_by(name: 'Arabic Poetry')
    res_ids = col.resources.map(&:id)
    sec_ids = Section.where(resource_id: res_ids)
    ContentUnit.where(section_id: sec_ids).delete_all
    Section.where(resource_id: res_ids).delete_all
    Resource.where(collection_id: col.id).delete_all
    col.destroy
    col = Collection.create(name: 'Arabic Poetry', metadata: { content_unit_type: 'line' })
    
    files_path = './corpora/adab'
    Dir.glob("#{files_path}/*").each do |filename|
      file_content = File.read filename
      json_data = JSON.parse(file_content)
      resource_data = json_data.with_indifferent_access
      resource = col.resources.create(
        uuid: resource_data[:uuid],
        name: resource_data[:name],
        metadata: resource_data[:metadata]
      )
      sections = resource_data[:sections]
      sections.each do |section_data|
        section = resource.sections.create(
          uuid: section_data[:uuid],
          name: section_data[:name],
          metadata: section_data[:metadata]
        )
        content_units = section_data[:content_units]
        content_units.each do |cu_data|
          section.content_units.create(
            uuid: cu_data[:uuid],
            name: cu_data[:name],
            content: cu_data[:content],
            metadata: cu_data[:metadata]
          )
        end
      end
    end
    ContentUnit.reindex
  end
end
