class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:info]
  def info
  end

  def show
   @room = Room.new
end
end
