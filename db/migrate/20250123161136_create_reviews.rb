class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :source_id, null: false
      t.string :user, null: false
      t.string :month, null: false
      t.integer :year, null: false, limit: 2
      t.integer :stars, null: false, default: 1
      t.text :content, null: false, default: ""

      t.references :listing, null: false, foreign_key: true
      t.timestamps
    end

    add_index :reviews, :year
    add_index :reviews, :source_id, unique: true
  end
end
