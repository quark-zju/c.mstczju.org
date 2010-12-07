require 'test_helper'

class ProblemLinksControllerTest < ActionController::TestCase
  setup do
    @problem_link = problem_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:problem_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create problem_link" do
    assert_difference('ProblemLink.count') do
      post :create, :problem_link => @problem_link.attributes
    end

    assert_redirected_to problem_link_path(assigns(:problem_link))
  end

  test "should show problem_link" do
    get :show, :id => @problem_link.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @problem_link.to_param
    assert_response :success
  end

  test "should update problem_link" do
    put :update, :id => @problem_link.to_param, :problem_link => @problem_link.attributes
    assert_redirected_to problem_link_path(assigns(:problem_link))
  end

  test "should destroy problem_link" do
    assert_difference('ProblemLink.count', -1) do
      delete :destroy, :id => @problem_link.to_param
    end

    assert_redirected_to problem_links_path
  end
end
