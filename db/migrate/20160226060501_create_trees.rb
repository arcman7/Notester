class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.references :category, index: true
      t.string     :name

      t.timestamps
    end
  end
end
