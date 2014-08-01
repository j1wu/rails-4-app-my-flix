class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end 

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.delete if relationship.follower == current_user
    redirect_to people_path
  end

  def create
    leader = User.find(params[:user_id])
    relationship = Relationship.new(follower: current_user, leader: leader)
    unless relationship.duplicated?
      relationship.save
      flash[:info] = "You are now following #{leader.full_name}"
    else
    end
    redirect_to people_path
  end

end
