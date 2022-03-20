class CreateEndpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :endpoints do |t|
      t.string :requested_type
      t.string :requested_verb
      t.string :requested_path

      t.timestamps
    end
  end
end
