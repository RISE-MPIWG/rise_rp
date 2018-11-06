require 'find'
require 'fileutils'

class CollectionFolderParser
  attr_reader :collection

  def self.parse_folder(collection)
    new(collection).parse_folder
  end

  def initialize(collection)
    @collection = collection
  end

  def parse_folder
    file_paths = []
    Find.find(collection.import_folder) do |path|
      file_paths << path if path =~ /.*\.txt$/
    end
    file_paths
  end

  def create_hierarchy
    file_paths = parse_folder
    debugger
    file_paths.each do |path|
      path_array = path.split('/')
      path_array.each_cons(2) do |previous, element|
        if previous == collection.name
          collection.resources.find_or_create_by(name: element)
        end

        if collection.resources.map(&:name).include? previous
          resource = collection.resources.find_by(name: previous)
          section = resource.sections.find_or_create_by(name: element)
          section.save
        end

        if collection.sections.map(&:name).include? previous
          parent_section = collection.sections.find_by(name: previous)
          if element.include? '.txt'
            file = File.open(path)
            file.each_line do |line|
              parent_section.content_units.find_or_create_by(name: element, content: line)
            end
          else
            resource = parent_section.resource
            section = resource.sections.find_or_create_by(name: element)
            section.parent = parent_section
            section.save
          end
        end
        collection.reload
      end
    end
  end


end
