class User < ActiveRecord::Base
  has_many :votes
  has_many :resources, through: :votes
  has_many :resources
end
