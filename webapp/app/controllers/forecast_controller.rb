class ForecastController < ApplicationController
  before_action :validate_params

  def index
    forecaster = ForecastService.new(params[:zip_code])
    @forecast = forecaster.call
    @is_cached = forecaster.is_cached
  end

  private

  def validate_params
    if !/^[0-9]{5}$/.match(params[:zip_code])
      flash[:error] = "You must provide a valid zip code"
      redirect_to :root
    end
  end
end
