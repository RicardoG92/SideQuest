class SideQuestsController < ApplicationController

  before_action :set_sidequest, only: [:show, :update, :destroy]
  before_action :set_review, only: [:show]


  def index
    @sidequests = SideQuest.all
    @markers = @sidequests.geocoded.map do |sidequest|
      {
        lat: sidequest.latitude,
        lng: sidequest.longitude
      }
    end
  end

  def new
    @sidequest = SideQuest.new
  end

  def create
    @sidequest = SideQuest.create(set_params)
    @sidequest.user = current_user
    @sidequest.category = Category.first
    if @sidequest.save!
      redirect_to side_quest_path(@sidequest), notice: "Sidequest was successfully created"
    else
      redirect_to new_side_quest_path, notice: "Sidequest details were not correct"
    end
  end

  def show
    @markers = [
      {
        lat: @sidequest.latitude,
        lng: @sidequest.longitude
      }
    ]
  end

  def edit
  end

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
end
