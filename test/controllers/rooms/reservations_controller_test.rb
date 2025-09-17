require "test_helper"

class Rooms::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get rooms_reservations_new_url
    assert_response :success
  end

  test "should get create" do
    get rooms_reservations_create_url
    assert_response :success
  end
end
