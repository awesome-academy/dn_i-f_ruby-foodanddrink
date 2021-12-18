class Admin::AdminsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  layout "admin"

  def index; end
end
