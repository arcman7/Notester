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

  def recurse_children(parent,current_node)
    return if parent.children.length == 0
    #p self.name
    current_node["children"] =  []
    parent.children.each{|child| current_node["children"].push({name: child.title, parent: child.parent.title, id: self.id }) }
    p current_node
    parent.children.each do |child|
      index     = current_node["children"].index{|node| node[:name] == child.title}
      next_node = current_node["children"][index]
      recurse_cats( child, next_node  )
    end
  end
  def get_tree_resources
    @@results = { name: self.title, parent: nil, self.id }
    recurse_children(self,@@results)
    @@results
  end
end
