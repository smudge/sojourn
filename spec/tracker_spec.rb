require 'spec_helper'
require 'securerandom'
require 'mocks/controller'

module Sojourn
  COOKIE_NAME = Sojourn.config.cookie_name

  describe Tracker do # rubocop:disable Metrics/BlockLength
    let(:user) { Mocks::User.new }
    let(:request) { Mocks::Request.new }
    let(:cookies) { Mocks::Cookie.new }
    let(:ctx) { Mocks::Controller.new(user, request, cookies) }
    let(:tracker) { Tracker.new(ctx) }

    describe '#track!' do
      let(:event_name) { 'foo' }
      let(:opts) { { bar: true } }
      before { tracker.track!(event_name, opts) }
      subject { Event.last }

      its(:user_id) { is_expected.to eq(user.id) }
      its(:name) { is_expected.to eq(event_name) }

      describe 'properties' do
        subject { Event.last.properties }

        its(:keys) { is_expected.to eq(%w[request browser bar]) }
        its(%i[request params]) { is_expected.to eq('filtered' => true) }
        its(%i[request method]) { is_expected.to eq('get') }
        its(%i[browser name]) { is_expected.to eq('Chrome') }
      end
    end

    describe '#sojourning!' do # rubocop:disable Metrics/BlockLength
      before { tracker.sojourning! }
      subject { Event.last }

      its(:name) { is_expected.to eq('!sojourning') }

      context 'when already tracked once' do
        before do
          tracker.update_session!
          Sojourn::Event.delete_all
          tracker.sojourning!
        end

        it { is_expected.to be_nil }
      end

      context 'when user changes' do
        before do
          tracker.update_session!
          Sojourn::Event.delete_all
          ctx.current_user = Mocks::User.new
          tracker.sojourning!
        end

        its(:name) { is_expected.to eq('!logged_in') }
      end

      context 'when user logs out' do
        before do
          tracker.update_session!
          Sojourn::Event.delete_all
          ctx.current_user = nil
          tracker.sojourning!
        end

        its(:name) { is_expected.to eq('!logged_out') }
      end

      context 'when user agent not present' do
        let(:request) { Mocks::Request.new(user_agent: nil) }

        its(:name) { is_expected.to eq('!sojourning') }

        describe 'properties' do
          subject { Event.last.properties }

          its(%i[browser known]) { is_expected.to be(false) }
          its(%i[browser name]) { is_expected.to be_nil }
        end
      end
    end

    describe 'update_session!' do
      subject { cookies }

      context 'before' do
        its([COOKIE_NAME]) { is_expected.to be_nil }
      end

      context 'after running' do
        before { tracker.update_session! }

        its([COOKIE_NAME, :uuid]) { is_expected.to_not be_nil }
        its([COOKIE_NAME, :user_id]) { is_expected.to eq(user.id) }

        context 'with existing cookie' do
          let(:sojourner_uuid) { SecureRandom.uuid }
          let(:cookie_data) { { user_id: user.id, uuid: sojourner_uuid } }
          let(:cookies) { Mocks::Cookie[{ COOKIE_NAME => cookie_data }] }

          its([COOKIE_NAME, :uuid]) { is_expected.to eq(sojourner_uuid) }
          its([COOKIE_NAME, :user_id]) { is_expected.to eq(user.id) }
        end
      end
    end
  end
end
