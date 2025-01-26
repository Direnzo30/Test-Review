class ListingsController < ApplicationController
  before_action :set_listing, only: [:show]
  REVIEWS_CHART_CONTAINER_ID = "reviews_chart_container".freeze

  def index
    @listings = current_user.listings.page(params[:page] || 1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
  end

  def create
    listing = Scrappers::Airbnb.new(url: params[:url], user_id: current_user.id).scrap
    if listing
      respond_to do |format|
        format.html { redirect_to listing }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @years = @listing.reviews_years
    @current_year = params[:year] || @years.last
    @reviews = @listing.reviews_by_month_for_year(@current_year)
    @words_for_cloud = @listing.words_for_cloud

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(REVIEWS_CHART_CONTAINER_ID,
                                                  partial: 'listings/chart',
                                                  locals: { current_year: @current_year, years: @years, reviews: @reviews, listing: @listing })
      end
    end
  end

  private

  def set_listing
    @listing ||= current_user.listings.find(params[:id])
  end
end
