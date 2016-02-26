class Tree < ActiveRecord::Base
  belongs_to :category #only to be used with Categories since all trees of this class are public
end