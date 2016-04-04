class Vote < ActiveRecord::Base
    belongs_to :resource
    belongs_to :user
    #validates :unique_identifier, uniqueness: true

    def unique_flag(user, resource)
      flag = user.id.to_s + "_" + resource.id.to_s
      #flag
    end
end


