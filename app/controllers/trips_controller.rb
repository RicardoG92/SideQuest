class TripsController < ApplicationController
  before_action :set_trip, only: %i[show update]
  before_action :set_sidequest, only: %i[index]

  def index
    @trips = current_user.trips
    @trips = Trip.all
  end

  def show
    @sidequests = SideQuest.first(3)
    # @sidequests = Sidequest.all
    # @markers = @trip.geocoded.map do
    # {
    #   lat: @trip.start_location.latitude,
    #   lng: @trip.end_location.longitude
    # }
    # end
  end

  def new
    @trip = Trip.new
    @category = Trip.new
    @location = Location.new
  end

  def create
    @trip = Trip.new(trip_params)
    @sidequests = SideQuest.all
    @trip.user = current_user
    if @trip.save
      redirect_to trip_path(@trip)
    else
      redirect_to new_trip_path
    end
  end

  def destroy
    @trip.destroy
    redirect_to trips_path
  end

  private

  def trip_params
    params.require(:trip).permit(:start_location_id, :end_location_id)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def set_sidequest
    @sidequest = SideQuest.find(params[:id])
  end
end
