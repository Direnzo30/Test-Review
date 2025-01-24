class ListingsController < ApplicationController

  def index
    @listings = current_user.listings.page(params[:page] || 1)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end


  def show

  end
end
