class CreateRelations < ActiveRecord::Migration
  def change
     create_table :relations do |t|
      t.references :child
      t.references :parent
      # t.integer :parent
      # t.integer :child
    end
  end
end
