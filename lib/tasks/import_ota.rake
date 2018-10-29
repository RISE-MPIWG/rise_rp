require 'fileutils'
require 'open-uri'

class StrictTsv
  attr_reader :filepath
  def initialize(filepath)
    @filepath = filepath
  end

  def parse
    open(filepath) do |f|
      headers = f.gets.strip.split("\t")
      f.each do |line|
        fields = Hash[headers.zip(line.split("\t"))]
        yield fields
      end
    end
  end
end

namespace :import do  
  desc 'import OTA corpus'
  task ota: :environment do
    files_path = './corpora/ota/text'
    col = Collection.find_or_create_by(name: 'Oxford Text Archive', metadata: { content_unit_type: 'line' })
    res_ids = col.resources.map(&:id)
    sec_ids = Section.where(resource_id: res_ids)
    ContentUnit.where(section_id: sec_ids).delete_all
    Section.where(resource_id: res_ids).delete_all
    Resource.where(collection_id: col.id).delete_all
    col.destroy

    col = Collection.find_or_create_by(name: 'Oxford Text Archive', metadata: { content_unit_type: 'line' })

    
    tsv = StrictTsv.new("./corpora/ota/metadata.tsv")
    tsv.parse do |row|
      id = row['ID']
      url = row['URL']
      title = row['Title']
      author = row['Author']
      year = row['Year']
      language = row['Language']
      license = row['License']

      language = case language
      when 'English'
        'en-GB'
      when 'Latin'
        'lat'
      else
        language
      end

      file = open(url)
      resource = col.resources.build(name: title, metadata: { author: author, language: language, year: year, license: license})
      section = resource.sections.build(name: resource.name)
      file.each_line do |line|
        unless (line.empty? || line =~ /\A\s*\Z/)
          section.content_units.build(content: line)
        end
      end
      resource.save
      section.save
    end
    ContentUnit.reindex
  end
end
