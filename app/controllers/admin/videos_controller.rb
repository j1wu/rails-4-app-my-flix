class Admin::VideosController < ApplicationController
  before_action :require_user, :require_admin

  def new
  end

end
