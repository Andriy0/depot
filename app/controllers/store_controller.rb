class StoreController < ApplicationController
  include VisitCounter
  include CurrentCart

  skip_before_action :authorize

  before_action :increment_counter, only: :index
  before_action :set_cart, only: :index

  def index
    redirect_to store_index_url(locale: params[:set_locale]) if params[:set_locale]

    @products = Product.order(:title)
  end
end
