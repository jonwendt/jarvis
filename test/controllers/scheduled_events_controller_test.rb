require 'test_helper'

class ScheduledEventsControllerTest < ActionController::TestCase
  setup do
    @scheduled_event = scheduled_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scheduled_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scheduled_event" do
    assert_difference('ScheduledEvent.count') do
      post :create, scheduled_event: {  }
    end

    assert_redirected_to scheduled_event_path(assigns(:scheduled_event))
  end

  test "should show scheduled_event" do
    get :show, id: @scheduled_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scheduled_event
    assert_response :success
  end

  test "should update scheduled_event" do
    patch :update, id: @scheduled_event, scheduled_event: {  }
    assert_redirected_to scheduled_event_path(assigns(:scheduled_event))
  end

  test "should destroy scheduled_event" do
    assert_difference('ScheduledEvent.count', -1) do
      delete :destroy, id: @scheduled_event
    end

    assert_redirected_to scheduled_events_path
  end
end
