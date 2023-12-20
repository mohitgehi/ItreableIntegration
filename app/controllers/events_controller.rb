class EventsController < ApplicationController
  def index
  end
  def event_a
    response = HTTParty.post(
      'https://api.iterable.com/api/events/track',
      body: 'Click event',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }
    )

    if response.code == 200
      flash[:notice] = "Event A tracked successfully!"
    else
      flash[:error] = "Failed to track Event A. Error: #{response.code}"
    end

    redirect_to root_path
  end

  def event_b
    response = HTTParty.post(
      'https://api.iterable.com/api/email/target',
      body: 'Some email body',
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      }
    )

    if response.code == 200
      flash[:notice] = "Event B triggered successfully!"
    else
      flash[:error] = "Failed to trigger Event B. Error: #{response.code}"
    end

    redirect_to root_path
  end
end
