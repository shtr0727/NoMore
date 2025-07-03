require "test_helper"

class NotTodosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get not_todos_index_url
    assert_response :success
  end

  test "should get show" do
    get not_todos_show_url
    assert_response :success
  end

  test "should get new" do
    get not_todos_new_url
    assert_response :success
  end

  test "should get edit" do
    get not_todos_edit_url
    assert_response :success
  end
end
