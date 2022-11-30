class StopsController < ApplicationController
  before_action :set_sidequest
  before_action :set_trip

  def new
    @stop = Stop.new
  end

  def create

  end

  def show

  end

  def edit

  end

  def destroy

  end

  private

  def set_sidequest
    @sidequest = SideQuest.find(params[:id])
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

end
