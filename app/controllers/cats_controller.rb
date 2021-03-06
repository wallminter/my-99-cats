class CatsController < ApplicationController

  before_action :verify_cat_ownership, only: [:edit, :update]
  before_action :verify_logged_in, only: [:new, :create]

  def index
    @cats = Cat.all

    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @cat_rental_requests = @cat.cat_rental_requests.order('start_date, status').includes(:requester)

    render :show
  end

  def new
    @cat = Cat.new

    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat.id)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])

    render :edit
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update(cat_params)
      redirect_to cat_url(@cat.id)
    else
      render :edit
    end

  end

  def destroy
    @cat = Cat.find(params[:id])

    @cat.destroy
    redirect_to cats_url
  end

  private

  def verify_cat_ownership
    @cat = current_user.cats.find(params[:id]) if current_user

    unless @cat
      flash[:errors] = "That's not your cat!"
      redirect_to cat_url(params[:id])
    end
  end

  def cat_params
    params.require(:cat).permit(:birth_date, :name, :color, :sex, :description)
  end
end
