# spec/controllers/events_controller_spec.rb
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe "POST #event_a" do
    it "tracks Event A successfully" do
      allow(HTTParty).to receive(:post).with(
        'https://api.iterable.com/api/events/track',
        body: 'Click event',
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        }
      ).and_return(double(code: 200))

      post :event_a

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Event A tracked successfully!")
    end

    it "handles failure to track Event A" do
      allow(HTTParty).to receive(:post).with(
        'https://api.iterable.com/api/events/track',
        body: 'Click event',
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        }
      ).and_return(double(code: 500))

      post :event_a

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("Failed to track Event A. Error: 500")
    end
  end

  describe "POST #event_b" do
    it "triggers Event B successfully" do
      allow(HTTParty).to receive(:post).with(
        'https://api.iterable.com/api/email/target',
        body: 'Some email body',
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        }
      ).and_return(double(code: 200))

      post :event_b

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Event B triggered successfully!")
    end

    it "handles failure to trigger Event B" do
      allow(HTTParty).to receive(:post).with(
        'https://api.iterable.com/api/email/target',
        body: 'Some email body',
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        }
      ).and_return(double(code: 404))

      post :event_b

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("Failed to trigger Event B. Error: 404")
    end
  end
end
