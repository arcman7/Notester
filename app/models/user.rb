class User < ActiveRecord::Base
  has_many :votes
  has_many :voted_on_resources, through: :votes, source: :resource
  has_many :resources
  has_many :trees, class_name: "Resource"

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  def authenticate(password)
    self.password == password
  end
end
