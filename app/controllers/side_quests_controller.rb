class SideQuestsController < ApplicationController
  before_action :set_sidequest, only: %i[show update destroy]
  before_action :set_review, only: %i[show]
  before_action :set_trip, only: %i[index show]

  def index
    @sidequests = SideQuest.all
    @markers = @sidequests.geocoded.map do |sidequest|
      {
        lat: sidequest.latitude,
        lng: sidequest.longitude,
        info_window: render_to_string(partial: "info_window", locals: {sidequest: sidequest}),
        image_url: helpers.asset_url("gray.png")
      }
    end
  end

  def show
    @reviews = @sidequest.reviews
    @review = Review.new
    @markers = [{
      lat: @sidequest.latitude,
      lng: @sidequest.longitude,
      info_window: render_to_string(partial: "info_window", locals: {sidequest: @sidequest})
    }]
  end

  def new
    @sidequest = SideQuest.new
  end

  def create
    @trip = Trip.last
    @sidequest = SideQuest.create(set_params)
    @sidequest.user = current_user
    # @TODO: use the category selected by the user!
    @sidequest.category = Category.first
    if @sidequest.save!
      redirect_to edit_trip_path(@trip), notice: "Sidequest was successfully created"
    else
      redirect_to new_side_quests_path, notice: "Sidequest details were not correct"
    end
  end


  def edit
  end

  def update
    if @sidequest.update(side_quest)
      redirect_to side_quests_path, notice: "Sidequest was successfully updated"
    else
      redirect_to new_side_quests_path, notice: 'Your details were not correct, try again'
    end
  end

  def destroy
    @sidequest.destroy
    redirect_to side_quests_path, notice: 'Your details were not correct, try again'
  end

  private

  def set_params
    params.require(:side_quest).permit(:name, :address, :description, :price, :photo)
  end

  def set_sidequest
    @sidequest = SideQuest.find(params[:id])
  end

  def set_review
   @review = Review.find_by(side_quest_id: params[:id])
  end

  def set_trip
    @trip = Trip.find(params[:trip_id])
 end
end
