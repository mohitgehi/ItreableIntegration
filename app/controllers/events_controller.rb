class EventsController < ApplicationController
  def index
  end

  def handle_event
    event_name = params[:event_name]
    response = EventsService.track_event(event_name)
    handle_response(response, event_name)
  end
  def send_email
    successful_emails = EventsService.trigger_email_for_fetched_events
    flash_messages(successful_emails)
    redirect_to root_path
  end

  private

  def handle_response(response, event_name)
    if response.code == 200
      flash[:notice] = "#{event_name} tracked successfully!"
    else
      flash[:error] = "Failed to track #{event_name}. Error: #{response.code}"
    end
    redirect_to root_path
  end

  def flash_messages(successfully_sent_emails)
    flash[:notice] ||= ''
    successfully_sent_emails.each do |event|
      flash[:notice] += "Email sent for #{event} "
    end
  end
end
