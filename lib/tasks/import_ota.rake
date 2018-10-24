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
    files_path = './ota/text'
    col = Collection.find_or_create_by(name: ' Oxford Text Archive', metadata: { content_unit_type: 'line' })
    
    tsv = StrictTsv.new("./ota/metadata.tsv")
    tsv.parse do |row|
      id = row['ID']
      url = row['URL']
      title = row['Title']
      author = row['Author']
      year = row['Year']
      language = row['Language']
      license = row['License']
      file = open(url)
      resource = col.resources.build(name: title, metadata: { author: author, language: language, year: year, license: license})
      section = resource.sections.build(name: resource.name)
      file.each_line do |line|
        section.content_units.build(content: line)
      end
      resource.save
      section.save
    end
  end
end
