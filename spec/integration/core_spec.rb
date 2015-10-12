# encoding: UTF-8

require 'spec_helper'
require 'support/account'
require 'wakatime'
require 'webmock/rspec'

describe Wakatime, skip: true do
  before do
    WebMock.allow_net_connect!
    @session = Wakatime::Session.new(
      api_key: ACCOUNT['api_key']
    )

    @client = Wakatime::Client.new(@session)
  end

  it 'raises an AuthError if not client auth fails' do
    session = Wakatime::Session.new(
      api_key: 'bad-key'
    )

    @bad_client = Wakatime::Client.new(session)

    expect { @bad_client.summary }.to raise_error(Wakatime::AuthError)
  end
  describe Wakatime::Client do
    it 'will return json scoped to specified times' do
      summary = @client.summary
      expect(summary).to be_a Wakatime::Models::Summaries
      expect(summary).to respond_to :grand_total
      expect(summary).to respond_to :projects
    end

    it 'will return json scoped to specified times' do
      heartbeats = @client.heartbeats
      expect(heartbeats).to be_a Array
      expect(heartbeats.first).to be_a Wakatime::Models::Action
      expect(heartbeats.first).to respond_to :file
      expect(heartbeats.first).to respond_to :time
    end

    it 'will return current user json' do
      current_user = @client.current_user
      expect(current_user).to be_a Wakatime::Models::User
      expect(current_user).to respond_to :email
      expect(current_user).to respond_to :timezone
    end

    it 'will return plugin usage json scoped to specified times' do
      plugins = @client.plugins
      expect(plugins).to be_a Array
      expect(plugins.first).to be_a Wakatime::Models::Plugin
      expect(plugins.first).to respond_to :name
    end

    it 'will return daily json scoped to specified times' do
      daily = @client.daily
      expect(daily).to be_a Array
      expect(daily.first).to be_a Wakatime::Models::Summary
      expect(daily.first).to respond_to :grand_total
      expect(daily.first).to respond_to :projects
    end
  end
end
