class CreateVotes < ActiveRecord::Migration
  def change
   create_table :votes  do |t|
     t.integer    :value
     t.references :user
     t.references :resource
     t.string     :unique_identifier

     t.timestamps
   end
  end
end
