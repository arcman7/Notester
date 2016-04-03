# class Node
#   attr_accessor :name, :nodes, :tags

#   def initialize(name, nodes,tags)
#     @name  = name
#     @nodes = nodes
#     @tags  = tags
#   end
# end

# class Iterator
#   def initialize(node)
#     @node = node
#   end

#   def each_node
#     yield @node
#     for node in @node.nodes do
#       iterator = Iterator.new(node)
#       iterator.each_node {|next_node|
#         yield next_node
#       }
#     end
#   end
# end


class Category < ActiveRecord::Base
  # Remember to create a migration!
  has_many :resource_categories
  has_many :resources, through: :resource_categories
  has_many :sub_categories, class_name: "Category", foreign_key: "parent_category_id"
  belongs_to :parent_category, class_name: "Category"

  has_many :category_tags
  has_many :tags, through: :category_tags
  has_one  :tree
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
  ######     Pass up array form  ######
  # def recurse_cats(parent)
  #   return if parent.sub_categories.length == 0
  #   p self.name
  #   @@results.concat(parent.sub_categories)
  #   parent.sub_categories.each do |subcat|
  #     recurse_cats(subcat)
  #   end
  # end
  # def get_tree_sub_cats
  #   @@results = [ ]
  #   node_array = [{ name: self.name, category_id: self.id, parent_id: nil, parent_name: nil }]
  #   recurse_cats(self)
  #   p @@results
  #   @@results.each {|cat| node_array.push({ name: cat.name, category_id: cat.id, parent_id: cat.parent_category.id, parent_name: cat.parent_category.name }) }
  #   #@@results
  #   node_array
  # end
  ######     Pass up tree form  ######

    def recurse_cats(parent,current_node)
      return if parent.sub_categories.length == 0
      #p self.name
      current_node["children"] =  []
      parent.sub_categories.each{|cat| current_node["children"].push({name: cat.name, parent: cat.parent_category.name, id: cat.id, parent_id: cat.parent_category.id }) }
      p current_node
      parent.sub_categories.each do |subcat|
        index     = current_node["children"].index{|node| node[:name] == subcat.name}
        next_node = current_node["children"][index]
        recurse_cats( subcat, next_node  )
      end
    end
    def get_tree_sub_cats
      @@results = { name: self.name, parent: nil, id: self.id, parent_id: nil }
      recurse_cats(self,@@results)
      @@results
    end
end

