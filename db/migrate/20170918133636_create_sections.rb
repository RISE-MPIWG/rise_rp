class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.belongs_to :resource
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :name
      t.jsonb :metadata
      t.index :metadata, using: :gin
      t.string :ancestry, index: true
      t.boolean :is_leaf, default: false, index: true
      t.timestamps
    end
  end
end
