class Tree < ActiveRecord::Base
  has_one :category #only to be used with Categories since all trees of this class are public
end