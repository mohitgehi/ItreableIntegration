require 'rails_helper'
require 'webmock/rspec'

RSpec.describe EventsService do
  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe '.track_event' do
    it 'tracks an event successfully' do
      event_name = 'Test Event'
      expected_response = { code: 200 }

      stub_request(:post, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/track')
        .with(
          body: hash_including(eventName: event_name)
        )
        .to_return(body: expected_response.to_json, status: 200)

      response = EventsService.track_event(event_name)
      expect(response.code).to eq(200)
    end
  end

  describe '.fetch_events_to_send' do
    it 'fetches events successfully' do
      expected_events = [
        { 'name' => 'Event A', 'email' => 'test@example.com', 'userId' => '123', 'messageId' => '456' },
        { 'name' => 'Event B', 'email' => 'another@test.com', 'userId' => '789', 'messageId' => '101112' }
      ]

      stub_request(:get, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/byUserId/1')
        .with(query: hash_including(limit: '30'))
        .to_return(body: { 'events' => expected_events }.to_json, status: 200)

      events = EventsService.fetch_events_to_send
      expect(events).to eq(expected_events)
    end
  end


  after do
    WebMock.allow_net_connect!
  end
end
