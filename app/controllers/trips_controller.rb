class TripsController < ApplicationController
  before_action :set_trip, only: %i[show update]
  before_action :set_sidequest, only: %i[index]

  def index
    # search feature needed
    @trips = current_user.trips
    @trips = Trip.all
  end

  def show
    @sidequests = SideQuest.all
    @markers = @sidequests.geocoded.map do |sidequest|

      {
        lat: sidequest.latitude,
        lng: sidequest.longitude,
        info_window: render_to_string(partial: "info_window", locals: {sidequest: sidequest})
      }
    end
    @sidequests2 = SideQuest.first(6)
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
    #@category = Trip.new
    #@location = Location.new
  end

  def create
    @trip = Trip.new
    @trip = Trip.first
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
    params.require(:trip).permit()
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def set_sidequest
    @sidequest = SideQuest.find(params[:id])
  end
end
