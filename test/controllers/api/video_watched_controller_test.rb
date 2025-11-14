require "test_helper"

class Api::VideoWatchedControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_video_watched_create_url
    assert_response :success
  end
end
