require 'rails_helper'
require 'webmock/rspec'

RSpec.describe EventsController, type: :controller do
  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe "POST #handle_event" do
    before do
      stub_request(:post, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/track')
        .to_return(status: 200)
    end

    context "when tracking an event" do
      it "tracks event and sets success flash message" do
        post :handle_event, params: { event_name: "successful_event" }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("successful_event tracked successfully!")
      end
    end

    context "when failing to track an event" do
      before do
        stub_request(:post, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/track')
          .to_return(status: 500)
      end

      it "handles tracking failure and sets error flash message" do
        post :handle_event, params: { event_name: "failed_event" }
        expect(response).to redirect_to(root_path)
        expect(flash[:error]).to eq("Failed to track failed_event. Error: 500")
      end
    end
  end

  describe "POST #send_email" do
    before do
      stub_request(:get, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/events/byUserId/1?limit=30')
        .with(headers: {
          'accept' => 'application/json',
          'api-key' => 'some-key'
        })
        .to_return(status: 200, body: { events: [] }.to_json)
    end

    context "when triggering emails successfully" do
      it "triggers emails and sets success flash message" do
        post :send_email
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_blank
      end
    end

    context "when failing to trigger emails" do
      before do
        stub_request(:post, 'https://ce59d6bc-698e-47fd-bb50-48af563ee148.mock.pstmn.io/api/email/target')
          .to_return(status: 500)
      end

      it "doesn't trigger emails and sets empty flash message" do
        post :send_email
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_blank
      end
    end
  end
end
