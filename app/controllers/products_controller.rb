class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy who_bought]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_product

  # GET /products or /products.json
  def index
    @products = Product.order(:title)
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
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

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }

        @products        = Product.all.order(:title)
        @current_product = @product
        ActionCable.server.broadcast 'products', render_to_string('store/index', layout: false)
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def who_bought
    @latest_order = @product.orders.order(:updated_at).last

    return unless stale?(@latest_order)

    respond_to do |format|
      format.atom
      format.html
      format.json { render json: @product.serializable_hash(include: :orders).to_json }
      format.xml  { render xml: @product.serializable_hash(include: :orders).to_xml }
    end
  end

  private

  def invalid_product
    logger.error "Attempt to access invalid product #{params[:id]}"
    redirect_to products_url, notice: 'Invalid product.'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:title, :description, :image_url, :price)
  end
end
