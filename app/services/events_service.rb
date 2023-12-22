require 'httparty'
require 'json'

class EventsService
  include HTTParty
  base_uri 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io'

  def self.track_event(event_name)
    post(
      '/api/events/track',
      body: {
        email: 'mohitgehi23@gmail.com',
        userId: 'id',
        eventName: event_name,
        id: 'someId',
        createdAt: '',
        dataFields: {},
        campaignId: 1,
        templateId: 1,
        createNewFields: false
      }.to_json,
      headers: {
        'accept' => 'application/json',
        'content-type' => 'application/json',
        'api-key' => 'some-key'
      }
    )
  end

  def self.email_sent?(email, userId, messageId)
    response = get(
      '/api/email/viewInBrowser',
      query: {
        email: email,
        userId: userId,
        messageId: messageId
      },
      headers: {
        'accept' => 'application/json',
        'api-key' => 'some-key'
      }
    )
    parsed_response = JSON.parse(response.body)
    parsed_response['msg'] == "true"
  end

  def self.fetch_events_to_send
  begin
    response = get(
      '/api/events/byUserId/1',
      query: {
        limit: 30,
      },
      headers: {
        'accept' => 'application/json',
        'api-key' => 'some-key'
      }
    )
    parsed_response = JSON.parse(response.body)
    events = parsed_response['events'] || []
    events
  end
end


  def self.trigger_email_for_fetched_events
    events_to_send = fetch_events_to_send
    unique_events = events_to_send.uniq { |hash| hash["name"] }
    successful_emails = []

    unique_events.each do |event|
      if email_sent?(event['email'], event['userId'], event['messageId'])
        response = post(
          '/api/email/target',
          body: {
            "campaignId": 1,
            "recipientEmail": "mohitgehi23@gmail.com",
            "recipientUserId": "id",
            "dataFields": {},
            "sendAt": "",
            "allowRepeatMarketingSends": false,
           "metadata": {}
        }.to_json,
          headers: {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'api-key' => 'some-key'
          }
        )
        successful_emails << event if response.code == 200
      end
    end
    successful_emails
  end
end
