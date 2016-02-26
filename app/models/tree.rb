class Tree < ActiveRecord::Base
  belongs_to :category
  validates :name, presence: true, uniqueness: true #only to be used with Categories since all trees of this class are public
end