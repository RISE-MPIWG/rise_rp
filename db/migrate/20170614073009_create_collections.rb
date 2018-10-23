class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections do |t|
      t.uuid :uuid, null: false, default: 'uuid_generate_v4()'
      t.string :name
      t.jsonb :metadata, null: false, default: '{}'
      t.index :metadata, using: :gin
      t.timestamps
    end
  end
end
