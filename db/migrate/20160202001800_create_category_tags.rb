class CreateCategoryTags < ActiveRecord::Migration
  def change
    create_table :category_tags do |t|
      t.references :category
      t.references :tag
    end
  end
end

