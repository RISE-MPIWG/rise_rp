require 'fileutils'
require 'csv'    


namespace :import do  
  desc 'import CENLAB corpus'
  task cenlab: :environment do
    col = Collection.find_or_create_by(name: 'Cenlab', metadata: { content_unit_type: 'paragraph' })
    res_ids = col.resources.map(&:id)
    sec_ids = Section.where(resource_id: res_ids)
    ContentUnit.where(section_id: sec_ids).delete_all
    Section.where(resource_id: res_ids).delete_all
    Resource.where(collection_id: col.id).delete_all
    col.destroy
    col = Collection.find_or_create_by(name: 'Cenlab', metadata: { content_unit_type: 'paragraph' })
    

    path = './corpora/cenlab/texts/'
    csv_text = File.read("./corpora/cenlab/cenlab-index.csv")
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      author = row['author']
      year = row['date']
      filename = row['filename']
      gender = row['gender']
      name = row['title']

      begin
        file = File.open("#{path}/#{filename}")
        resource = col.resources.build(name: name, metadata: { author: author, language: 'en-GB', year: year, gender: gender})
        section = resource.sections.build(name: resource.name)
        content = ""
        puts "FILENAME: #{filename}"
        begin
          file.each_line do |line|
            unless (line.empty? || line =~ /\A\s*\Z/)
              section.content_units.build(content: line)
            end
          end
        rescue
        end
        resource.save
        section.save
      rescue
      end
    end
  end
end
