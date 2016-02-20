class Relation < ActiveRecord::Base
  # Remember to create a migration!
    #Parent setup
    belongs_to :parent, foreign_key:"parent_id", class_name:"Resource"
    belongs_to :child, foreign_key:"child_id", class_name:"Resource"
   # belongs_to :resource

    def distinct_child_parent
      errors.add(:parent_id, "a resource cant be parent of itself") if self.parent_id == self.child_id
    end

end
