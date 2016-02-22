class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string     :title
      t.text       :description
      t.binary     :file
      t.references :user

      t.timestamps
    end
  end
end
