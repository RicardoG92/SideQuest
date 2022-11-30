class StopsController < ApplicationController
  before_action :set_sidequest
  before_action :set_trip
  before_action :set_stop

  def index
    @stops = Stop.all
  end

  def show; end

  def new
    @stop = Stop.new
    @category = Trip.new
    @location = Location.new
  end

  def create
    @stop = current_user.trips
    if @stop.save
      redirect_to side_quests_path, notice: "#{stop.name} has been added to your trip"
    else
      redirect_to side_quest_path(@sidequest), notice: "#{stop.name} has not been added to your trip"
    end
  end

  def edit; end

  def destroy
    @stop.destroy
    redirect_to side_quests_path, notice: "#{stop.name} has been removed from your trip"
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
