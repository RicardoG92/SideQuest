class ReviewsController < ApplicationController
  before_action :set_sidequest, only: %i[index create]

  def index
    @reviews = Review.all
  end

  def new
    @sidequest = set_sidequest
    @review = Review.new
  end

  def create

    @review = Review.create(set_params)
    @review.side_quest = @sidequest
    @review.user = current_user
    @review.save
    if @sidequest.save
      redirect_to side_quest_path(@sidequest, @review)
    else
      redirecto_to new_side_quest_path
    end
  end

  private

  def set_sidequest
    @sidequest = SideQuest.find(params[:side_quest_id])
  end

  def set_params
    params.require(:review).permit(:body, :rating)
  end

end
