require 'fileutils'

namespace :import do  
  desc 'import Novels corpus'
  task novels: :environment do
    files_path = './corpora/novels'
    col = Collection.find_or_create_by(name: 'A Multilingual Data Set of Novels', metadata: { content_unit_type: 'line' })
    res_ids = col.resources.map(&:id)
    sec_ids = Section.where(resource_id: res_ids)
    ContentUnit.where(section_id: sec_ids).delete_all
    Section.where(resource_id: res_ids).delete_all
    Resource.where(collection_id: col.id).delete_all
    col.destroy
    col = Collection.find_or_create_by(name: 'A Multilingual Data Set of Novels', metadata: { content_unit_type: 'line' })

    Dir.glob("#{files_path}/*").each do |filename|
      next if File.directory?(filename)
      name = File.basename(filename).delete('.txt')
      metadata = name.split('_')
      language = metadata[0]
      year = metadata[1]
      author = metadata[2]
      title = metadata[3].underscore.humanize.titleize
      book_type = metadata[4]
      file = File.open(filename)

      language = case language
      when 'EN'
        'en-GB'
      when 'DE'
        'de-DE'
      when 'FR'
        'fr-FR'
      else
        language
      end

        

      resource = col.resources.build(name: title, metadata: { author: author, language: language, year: year, book_type: book_type, content_unit_type: 'line'})
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
