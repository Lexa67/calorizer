class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:search]

  before_action :authenticate_user!
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.all
    @mobility_options = mobility_options
    @calories_for_user = current_user.weight * current_user.goal_value
    @proteins = (@calories_for_user * 0.3 / 4).ceil(1)
    @fats = (@calories_for_user * 0.1 / 9).ceil(1)
    @carbohydrates = (@calories_for_user * 0.6 / 4).ceil(1)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    if params[:search].present?
      @products = Product.where('name ILIKE ?', "%#{params[:search]}%")
    else
      @products = Product.all
    end
    respond_to do |format|
      format.js # search.js.erb
      format.html
    end
  end

  def add
    @product = Product.find(params[:id])
    
    respond_to do |format|
      format.js
      format.html { redirect_to products_path, notice: 'Product was successfully added.' }
    end
  end

  private
  
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :product_type, :protein, :fat, :carbohydrates, :calories)
    end

    def mobility_options
      [
        'очень низкая подвижность (сидячий образ жизни)',
        'низкая подвижность (небольшая физическая активность)',
        'средняя подвижность (регулярные занятия спортом)',
        'высокая подвижность (активный образ жизни)',
        'очень высокая подвижность (интенсивные тренировки)'
      ]
    end
end
