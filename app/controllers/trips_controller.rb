require 'json'
require 'net/http'
class TripsController < ApplicationController
  before_action :set_trip, only: %i[show update destroy edit]
  #before_action :set_sidequest, only: %i[index]

  def index
    @trips = current_user.trips
    # to be removed once the multiple trips can be displayed
  end

  def show
    # Show controller should only show the SQ that are a part of the trip
    @sidequests = @trip.stops.map { |stop| stop.side_quest }
    # @start_end_points = @trip.start_geolocation
    @markers = @sidequests.map do |sidequest|
      {
        lat: sidequest.latitude,
        lng: sidequest.longitude,
        stop_is_in_trip: Stop.where(trip: @trip, side_quest: sidequest).size.positive?,
        image_url: helpers.asset_url("gray.png"),
        info_window: render_to_string(partial: "info_window", locals: {sidequest: sidequest})
      }
    end

    start_end_markers = [@trip.start_geolocation, @trip.end_geolocation].map do |location|
      {
        lat: location['lat'],
        lng: location['lon'],
        is_start_end: true,
        image_url: helpers.asset_url("yellow.png")
      }
    end
    @markers.unshift(start_end_markers.first) # add start point to begining of markers
    @markers.push(start_end_markers.last) # end end point to end of markers
  end

  def new
    @sidequest = SideQuest.first
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    start_results = Geocoder.search(@trip[:start_location])
    end_results = Geocoder.search(@trip[:end_location])

    if start_results.blank? || end_results.blank?
      Trip.find(@trip.id).destroy
      redirect_to new_trip_path(), notice: "One or more of your addresses was not found"
      return false
    end

    @trip.start_geolocation = start_results.first.data
    @trip.end_geolocation = end_results.first.data

    @trip.user = current_user
    if @trip.save
      redirect_to edit_trip_path(@trip)
    else
      redirect_to new_trip_path
    end
  end

  def update; end

  def edit
    route_info = get_mapbox_route_info_for_trip(@trip[:start_location], @trip[:end_location])

    points = route_info['geometry']['coordinates']
    trip_distance_in_meters = route_info['distance']
    search_radius = trip_distance_in_meters / 1_000 / 5

    @sidequests = get_sidequests_within_radius_of_route(points, search_radius)

    @markers = @sidequests.map do |sidequest|
      {
        lat: sidequest.latitude,
        lng: sidequest.longitude,
        info_window: render_to_string(partial: "info_window", locals: {sidequest: sidequest}),
        stop_is_in_trip: Stop.where(trip: @trip, side_quest: sidequest).size.positive?,
        image_url: helpers.asset_url("gray.png")
      }
    end

    start_end_markers = [points.first, points.last].map do |location|
      {
        lat: location.last,
        lng: location.first,
        is_start_end: true,
        image_url: helpers.asset_url("yellow.png")
      }
    end
    @markers.unshift(start_end_markers.first) # add start point to begining of markers
    @markers.push(start_end_markers.last) # end end point to end of markers
  end

  def destroy
    @trip.destroy
    redirect_to trips_path
  end

  private

  def get_mapbox_route_info_for_trip(start_location, end_location)
    start_geo_result = Geocoder.search(start_location).first
    end_geo_result = Geocoder.search(end_location).first

    # stringify coords for url
    start_coords = start_geo_result.coordinates.reverse.join('%2C')
    end_coords = end_geo_result.coordinates.reverse.join('%2C')
    coordinates = [start_coords, end_coords].join('%3B')

    mapbox_api_url = URI("https://api.mapbox.com/directions/v5/mapbox/driving/#{coordinates}?alternatives=false&geometries=geojson&language=en&overview=full&steps=false&access_token=#{ENV['MAPBOX_API_KEY']}")
    mapbox_api_response = Net::HTTP.get_response(mapbox_api_url).body
    mapbox_api_json = JSON.parse(mapbox_api_response)
    mapbox_api_json['routes'][0]
  end

  def distance(first, second)
    Geocoder::Calculations.distance_between(first, second)
  end

  def simplify_coordinate_list(points, radius)
    next_point_proximity_to_skip = radius / 15
    every_nth_point = [points.first]
    i = 0
    j = 1
    while i <= points.size do
      this_point = points[i]
      next_point = points[i+j]
      break if next_point.blank?

      these_coords = [this_point.first, this_point.second]
      next_coords = [next_point.first, next_point.second]
      km_to_next_point = distance(these_coords, next_coords)
      next_point_is_too_close = km_to_next_point < next_point_proximity_to_skip

      if next_point_is_too_close
        j = j + 1
      else
        every_nth_point << points[i+j]
        i = i + j
        j = 1
      end
    end
    every_nth_point << points.last
  end

  def get_sidequests_within_radius_of_route(points, radius)
    simplified_points = simplify_coordinate_list(points, radius)
    possible_sidequests = []
    simplified_points.map do |point|
      sidequests_near_point = SideQuest.near(point.reverse, radius)
      possible_sidequests.concat(sidequests_near_point) unless sidequests_near_point.blank?
    end
    possible_sidequests.uniq! || []
  end

  def trip_params
    params.require(:trip).permit(:start_location, :end_location, :categories)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def set_sidequest
  end

  def set_category
    @category = Category.find(side_quest_id: params[:id])
  end
end
