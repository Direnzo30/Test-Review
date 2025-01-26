class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :word, null: false
      t.integer :count, null: false, default: 0

      t.references :listing, null: false, foreign_key: true
      t.timestamps
    end

    add_index :tags, [:listing_id, :word], unique: true
  end
end
