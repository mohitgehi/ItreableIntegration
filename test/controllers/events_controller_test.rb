require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "should track Event A successfully" do
    HTTParty.expects(:post).with(
      'https://api.iterable.com/api/events/track',
      body: 'Click event',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }
    ).returns(stub(code: 200))

    post :event_a

    assert_redirected_to root_path
    assert_equal "Event A tracked successfully!", flash[:notice]
  end

  test "should handle failure to track Event A" do
    HTTParty.expects(:post).with(
      'https://api.iterable.com/api/events/track',
      body: 'Click event',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }
    ).returns(stub(code: 500))

    post :event_a

    assert_redirected_to root_path
    assert_equal "Failed to track Event A. Error: 500", flash[:error]
  end

  test "should trigger Event B successfully" do
    HTTParty.expects(:post).with(
      'https://api.iterable.com/api/email/target',
      body: 'Some email body',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }
    ).returns(stub(code: 200))

    post :event_b

    assert_redirected_to root_path
    assert_equal "Event B triggered successfully!", flash[:notice]
  end

  test "should handle failure to trigger Event B" do
    HTTParty.expects(:post).with(
      'https://api.iterable.com/api/email/target',
      body: 'Some email body',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }
    ).returns(stub(code: 404))

    post :event_b

    assert_redirected_to root_path
    assert_equal "Failed to trigger Event B. Error: 404", flash[:error]
  end
end
