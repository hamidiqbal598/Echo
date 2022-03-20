class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses do |t|
      t.integer :code
      t.string :body
      t.text :headers
      t.belongs_to :endpoint, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end
end
