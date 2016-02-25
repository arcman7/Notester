class CategoryTag < ActiveRecord::Base
  belongs_to :category
  belongs_to :tag
end

#A tree can be generated off of a single resource
#A user can have a resource with 4 blank default children
#A user can have a resource