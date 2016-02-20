class Tag < ActiveRecord::Base
  has_many :resource_tags
  has_many :resources, through: :resource_tags

  has_many :category_tags
  has_many :categories, through: :category_tags
end
