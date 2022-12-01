class CategoryController < ApplicationController
  before_action :set_sidequest, only: %i[show]
  before_action :set_category, except: %i[index]

  def index
    @categorys = Category.all
  end

  def show;end

  def new
    @category = Category.new
    @sidequest = SideQuest.new
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user
    raise
    if @category.save
      raise
      redirect_to side_quest_path, notice: "#{category.name} has been saved"
    else
      raise
      redirect_to new_side_quest_path, notice: "#{category.name} has not been saved, please try again"
    end
  end

  def edit;end

  def destroy
    @category.destroy
  end

  private

  def set_category
    @category = Category.find_by(sidequest_id: params[:id])
  end

  def set_params
    params.require(:category).permit(:name)
  end

  def set_sidequest
    @sidequest = SideQuest.find(params[:id])
  end
end
