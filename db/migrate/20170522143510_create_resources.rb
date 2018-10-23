class CreateResources < ActiveRecord::Migration[5.1]
  def change
    create_table :resources do |t|
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.belongs_to :collection
      t.string :name
      t.string :uri
      t.jsonb :content
      t.jsonb :metadata
      t.index :metadata, using: :gin
      t.timestamps
    end
  end
end
