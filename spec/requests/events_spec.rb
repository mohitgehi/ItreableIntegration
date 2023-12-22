require 'rails_helper'
require 'webmock/rspec'

RSpec.describe EventsService do
  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe '.track_event' do
    before do
      stub_request(:post, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/track')
        .to_return(status: 200)
    end

    context 'when tracking an event successfully' do
      it 'tracks event and returns a success response' do
        response = EventsService.track_event('successful_event')
        expect(response.code).to eq(200)
      end
    end

    context 'when failing to track an event' do
      before do
        stub_request(:post, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/track')
          .to_return(status: 500)
      end

      it 'handles tracking failure and returns an error response' do
        response = EventsService.track_event('failed_event')
        expect(response.code).to eq(500)
      end
    end
  end

  describe '.fetch_events_to_send' do
    before do
      stub_request(:get, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/byUserId/1?limit=30')
        .with(headers: {
          'accept' => 'application/json',
          'api-key' => 'some-key'
        })
        .to_return(status: 200, body: { events: [] }.to_json)
    end

    context 'when fetching events successfully' do
      it 'fetches events and returns a success response' do
        events = EventsService.fetch_events_to_send
        expect(events).to be_an(Array)
      end
    end

    # Add more contexts and tests for various scenarios related to fetching events
  end

  # Add more describe blocks for testing other methods in EventsService

  after do
    WebMock.allow_net_connect!
  end
end
