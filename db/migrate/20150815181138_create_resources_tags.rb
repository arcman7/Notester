class CreateResourcesTags < ActiveRecord::Migration
  def change
    create_table :resource_tags, :id => false do |t|
      t.references :resource
      t.references :tag
    end
  end
end
