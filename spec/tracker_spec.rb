require 'spec_helper'
require 'mocks/controller'

module Sojourn
  describe Tracker do
    let(:user) { Mocks::User.new }
    let(:request) { Mocks::Request.new }
    let(:ctx) { Mocks::Controller.new(user, request) }
    let(:tracker) { Tracker.new(ctx) }

    describe '#track!' do
      let(:event_name) { 'foo' }
      let(:opts) { { bar: true } }
      before { tracker.track!(event_name, opts) }

      it 'should create an event' do
        expect(Event.count).to eq(1)
      end
    end
  end
end
