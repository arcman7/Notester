class Node
  attr_accessor :name, :nodes, :tags

  def initialize(name, nodes,tags)
    @name  = name
    @nodes = nodes
    @tags  = tags
  end
end

class Iterator
  def initialize(node)
    @node = node
  end

  def each_node
    yield @node
    for node in @node.nodes do
      iterator = Iterator.new(node)
      iterator.each_node {|next_node|
        yield next_node
      }
    end
  end
end


class Category < ActiveRecord::Base
  # Remember to create a migration!
  has_many :resource_categories
  has_many :resources, through: :resource_categories
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_category_id"
  belongs_to :parent_category, class_name: "Category"

  has_many :category_tags
  has_many :tags, through: :category_tags
  #this method needs some work
  # def sum_subcategories_tags(tag)
  #   tag_count = 0
  #   parent = Node.new(self.name, self.sub_categories, self.tags)
  #   iterator = Iterator.new(parent)
  #   if self.tags.include? tag
  #     tag_count += 1
  #   end
  #   iterator.each_node do |node|
  #     if node.tags.include? tag
  #       tag_count +=1
  #     end
  #   end
  #   tag_count
  # end
  def recurse_cats(parent)
    return if parent.sub_categories.length == 0
    p self.name
    @@results.concat(parent.sub_categories)
    parent.sub_categories.each do |subcat|
      recurse_cats(subcat)
    end
  end
  def get_tree_sub_cats
    @@results = [ ]
    node_array = []
    recurse_cats(self)
    p @@results
    @@results.each {|cat| node_array.push({ name: cat.name, category_id: cat.id, parent_id: cat.parent_category.id }) }
    node_array.unshift({ name: self.name, category_id: self.id, parent_id: nil })
    #@@results
    node_array
  end
end #Category.first.get_tree_sub_cats
