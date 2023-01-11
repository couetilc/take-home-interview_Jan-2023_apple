module ForecastHelper
  def zip_code
    params[:zip_code]
  end

  def timezone
    @forecast["timezone"]
  end

  def is_cached
    @is_cached
  end

  def current_temp
    @forecast["current_weather"]["temperature"]
  end

  def current_temp_max
    @forecast["daily"]["temperature_2m_max"].first
  end

  def current_temp_min
    @forecast["daily"]["temperature_2m_min"].first
  end

  def windspeed
    @forecast["current_weather"]["windspeed"]
  end

  def wind_direction
    @forecast["current_weather"]["winddirection"]
  end

  def current_time
    Time.parse(@forecast["current_weather"]["time"]).to_formatted_s(:long_ordinal)
  end

  def cache_status
    return "Stale" if is_cached
    "Fresh"
  end

  def pretty_forecast
    JSON.pretty_generate(@forecast)
  end
end
