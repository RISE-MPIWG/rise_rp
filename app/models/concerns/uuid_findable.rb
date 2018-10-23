module UuidFindable
  extend ActiveSupport::Concern
  included do
    def self.from_uuid(uuid)
      find_by(uuid: uuid) || raise(ActiveRecord::RecordNotFound)
    end
  end
end
