require 'test_helper'

class MealTimesControllerTest < ActionController::TestCase
  setup do
    @meal_time = meal_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meal_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meal_time" do
    assert_difference('MealTime.count') do
      post :create, meal_time: {  }
    end

    assert_redirected_to meal_time_path(assigns(:meal_time))
  end

  test "should show meal_time" do
    get :show, id: @meal_time
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meal_time
    assert_response :success
  end

  test "should update meal_time" do
    patch :update, id: @meal_time, meal_time: {  }
    assert_redirected_to meal_time_path(assigns(:meal_time))
  end

  test "should destroy meal_time" do
    assert_difference('MealTime.count', -1) do
      delete :destroy, id: @meal_time
    end

    assert_redirected_to meal_times_path
  end
end
