class SideQuestsController < ApplicationController

  before_action :set_sidequest, only: %i[show update edit destroy]
  before_action :set_review, only: %i[show]
  before_action :set_category, only: %i[index]


  def index
    @sidequests = current_user.sidequests
    # @mysidequests = current_user
    @sidequests = SideQuest.all
    @markers = @sidequests.geocoded.map do |sidequest|

      {
        lat: sidequest.latitude,
        lng: sidequest.longitude,
        info_window: render_to_string(partial: "info_window", locals: {sidequest: sidequest})
      }
    end
  end

  def show
    @reviews = Review.first(3)
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
    @mysidequest = SideQuest.create(set_params)
    @mysidequest.user = current_user
    @mysidequest.category = Category.first
    if @mysidequest.save!
      redirect_to mysidequests_path, notice: "Sidequest was successfully created"
    else
      redirect_to new_side_quest_path, notice: "Sidequest details were not correct"
    end
  end

  def mysidequests
    @mysidequests = SideQuest.all
  end

  def edit; end

  def update
    if @sidequest.update(side_quest)
      redirect_to side_quest_path, notice: "Sidequest was successfully updated"
    else
      redirect_to new_side_quest_path, notice: 'Your details were not correct, try again'
    end
  end

  def destroy
    @sidequest.destroy
    redirect_to side_quests_path, notice: 'Your details were not correct, try again'
  end

  private

  def set_params
    params.require(:side_quest).permit(:name, :address, :description, :price)
  end

  def set_sidequest
    @sidequest = SideQuest.find(params[:id])
  end

  def set_review
    @review = Review.find_by(side_quest_id: params[:id])
  end

  def set_category
    @category = Category.find_by(category_id:)
  end
  # def set_trip
  #   @trip
  # end
end
