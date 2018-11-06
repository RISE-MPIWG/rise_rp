require 'fileutils'
require 'csv'    


namespace :import do  
  desc 'import CENLAB corpus'
  task corpus_db: :environment do
    col = Collection.find_or_create_by(name: 'Corpus DB', metadata: { content_unit_type: 'line' })
    res_ids = col.resources.map(&:id)
    sec_ids = Section.where(resource_id: res_ids)
    ContentUnit.where(section_id: sec_ids).delete_all
    Section.where(resource_id: res_ids).delete_all
    Resource.where(collection_id: col.id).delete_all
    col.destroy
    col = Collection.find_or_create_by(name: 'Corpus DB', metadata: { content_unit_type: 'line' })
    

    path = './corpora/corpus_db/texts/'
    csv_text = File.read("./corpora/corpus_db/corpus_db_index.csv")
    csv = CSV.parse(csv_text, headers: true)
    api_url = "http://corpus-db.org/api"
    csv.each do |row|
      id = row['id']
      title = row['title']
      author = row['title']
      next if id == '0.0'
      #begin
        metadata_request = open("#{api_url}/id/#{id}")
        full_text_request = open("#{api_url}/id/#{id}/fulltext")

        metadata = JSON.parse(metadata_request.read)
        full_text = JSON.parse(full_text_request.read)

        resource = col.resources.build(name: title, metadata: metadata)
        section = resource.sections.build(name: resource.name)
        resource.save
        section.save
        begin
          cus = []
          full_text.first['text'].each_line do |line|
            unless (line.empty? || line =~ /\A\s*\Z/)
              cus << { content: line }
            end
          end
          section.content_units.create(cus)
        rescue
        end
      #rescue
      #end
    end
  end
end