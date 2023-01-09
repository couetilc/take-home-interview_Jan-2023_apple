require "test_helper"

class ForecastControllerTest < ActionDispatch::IntegrationTest
  test "should return forecast results with proper zip code" do
    get forecast_url, params: { zip_code: '12345' }
    assert_response :success
  end

  test "should return to home page with improper zip code" do
    get forecast_url
    assert_redirected_to controller: 'home', action: 'index'
  end
end
