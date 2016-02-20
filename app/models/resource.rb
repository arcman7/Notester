class Resource < ActiveRecord::Base
  # Remember to create a migration!
 belongs_to :user
  #Child of many parents through foreign key
  has_many :parent_relations, foreign_key: :child_id, class_name: "Relation"
  has_many :parents, through: :parent_relations, source: :parent


  #Parent of many children trhrough foreign key

  has_many :child_relations, foreign_key: :parent_id, class_name: "Relation"
  has_many :children, through: :child_relations, source: :child



  has_many :resource_categories
  has_many :categories, through: :resource_categories

  has_many :resource_tags
  has_many :tags, through: :resource_tags

  has_many :votes
  has_many :users, through: :votes
end
