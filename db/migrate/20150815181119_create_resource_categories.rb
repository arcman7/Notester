class CreateResourceCategories < ActiveRecord::Migration
  def change
    create_table :resource_categories, :id => false do |t|
      t.references :resource
      t.references :category
    end
  end
end
