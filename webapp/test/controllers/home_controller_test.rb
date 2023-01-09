require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should return forecast form" do
    get root_path
    assert_select 'form'
    assert_response :success
  end
end
