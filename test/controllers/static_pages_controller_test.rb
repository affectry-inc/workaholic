require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "株式会社Linkage - 勤怠管理システム"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact | 株式会社Linkage - 勤怠管理システム"
  end
end
