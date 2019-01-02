require 'fileutils'
require 'octokit'

namespace :import do
  desc 'import Esukhia Corpus'
  task esukhia: :environment do

    collection = Collection.find_or_create_by(name: 'Esukhia', metadata: { content_unit_type: 'line' })
    resources_ids = collection.resources.map(&:id)
    sections_ids = Section.where(resource_id: resources_ids)
    ContentUnit.where(section_id: sections_ids).delete_all
    Section.where(resource_id: resources_ids).delete_all
    Resource.where(collection_id: collection.id).delete_all
    collection.destroy
    
    collection = Collection.find_or_create_by(name: 'Esukhia', metadata: { content_unit_type: 'line' })

    client = Octokit::Client.new
    esukhia_resources = client.contents('Esukhia/Corpora', path: "Parallel/84000").select{ |i| i.name[/\.txt$/] }

    FileUtils.mkdir_p './corpora/esukhia'

    esukhia_resources.each do |esukhia_resource|
      filename = "./corpora/esukhia/#{esukhia_resource.name}"

      unless File.exists?(filename)
        File.open(filename, "wb") do |file|
          file.write open(esukhia_resource.download_url).read
        end
      end

    end

    Dir.glob("./corpora/esukhia/*").sort.each do |filename|
      name = File.basename(filename).delete('.txt')
      file = File.open(filename)
      resource = collection.resources.build(name: name)
      section = resource.sections.build(name: resource.name)

      file.each_line do |line|
        unless (line.empty? || line =~ /\A\s*\Z/)
          section.content_units.build(content: line)
        end
      end

      resource.save
      section.save

    end
  end
end
