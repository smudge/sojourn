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
      subject { Event.last }

      its(:user_id) { is_expected.to eq(user.id) }
      its(:name) { is_expected.to eq(event_name) }

      describe 'request' do
        subject { Event.last.request }

        its(:params) { is_expected.to eq('filtered' => true) }
        its(:method) { is_expected.to eq(:get) }
      end

      describe 'properties' do
        subject { Event.last.properties }

        its(:keys) { is_expected.to eq(%w(browser bar)) }
        its([:browser, :name]) { is_expected.to eq('Chrome') }
      end
    end
  end
end
