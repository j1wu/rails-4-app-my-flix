class Relationship < ActiveRecord::Base

  belongs_to :leader, class_name: 'User' 
  belongs_to :follower, class_name: 'User' 

  def duplicated?
    # Relationship.all.map(&:follower).include? self.follower and Relationship.all.map(&:leader).include? self.leader
    Relationship.pluck(:follower_id).include? self.follower.id and Relationship.pluck(:leader_id).include? self.leader.id
  end

end
