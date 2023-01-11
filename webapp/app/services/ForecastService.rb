require 'uri'
require 'net/http'

class ForecastService
  attr_reader :is_cached

  def self.call(zip_code)
    new(zip_code).call
  end

  def initialize(zip_code)
    @zip_code = zip_code
    @is_cached = nil
  end

  def call
    @is_cached = true # innocent until proven guilty

    Rails.cache.fetch(cache_key, cache_options) do

      @is_cached = false

      geo_api = URI::HTTPS.build({
        host: "geocoding-api.open-meteo.com",
        path: "/v1/search",
        query: { name: @zip_code }.to_query
      })

      response = Net::HTTP.get_response(geo_api)

      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.error "oops gotta do something else."
        Rails.logger.error response.body
        raise StandardError
      end

      location = JSON.parse(response.body)["results"].first

      weather_api = URI::HTTPS.build({
        host: "api.open-meteo.com",
        path: "/v1/forecast",
        query: [
          "timezone=#{location["timezone"]}",
          "latitude=#{location["latitude"]}",
          "longitude=#{location["longitude"]}",
          "current_weather=true",
          "daily=temperature_2m_min",
          "daily=temperature_2m_max",
          "hourly=temperature_2m",
          "temperature_unit=fahrenheit",
        ].join('&')
      })

      response = Net::HTTP.get_response(weather_api)

      unless response.is_a?(Net::HTTPSuccess)
        Rails.logger.error "oops gotta do something else."
        Rails.logger.error response.body
        raise StandardError
      end

      JSON.parse(response.body)
    end
  end

  private

  def cache_key
    "forecast-#{@zip_code}"
  end

  def cache_options
    {
        expires_in: 30.minutes,
    }
  end

end
