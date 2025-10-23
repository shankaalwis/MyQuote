require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get aindex" do
    get home_aindex_url
    assert_response :success
  end

  test "should get uindex" do
    get home_uindex_url
    assert_response :success
  end
end
