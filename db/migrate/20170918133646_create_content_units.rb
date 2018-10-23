class CreateContentUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :content_units do |t|
      t.belongs_to :section
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.belongs_to :resource
      t.jsonb :metadata
      t.index :metadata, using: :gin
      t.string     :name
      t.string     :content
      t.timestamps
    end
  end
end
