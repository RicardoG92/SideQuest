class StopsController < ApplicationController
  before_action :set_sidequest
  before_action :set_trip
  before_action :set_stop

  def index
    @stops = Stop.all
  end

  def show
    @stop = Stop.find(param[:id])
  end

  def new
    @stop = Stop.new
    @category = Trip.new
    @location = Location.new
  end

  def create
    @stop = current_user.sidequests
    #if @stop.save

  end


  def edit

  end

  def destroy
    @stop.destroy
  end

  private

  def stop_params
    params.require(:stop).permit(:trip)
  end

  def set_stop
    @stop = Stop.find_by(trip_id: params[:id])
  end

  def set_sidequest
    @sidequest = SideQuest.find(params[:id])
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

end
