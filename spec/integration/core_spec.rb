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

    lambda { @bad_client.summary }.should raise_error(Wakatime::AuthError)
  end
  describe Wakatime::Client do

    it 'will return json scoped to specified times' do
      summary = @client.summary
      summary.should be_a Wakatime::Models::Summary
      summary.should respond_to :grand_total
      summary.should respond_to :projects
    end

    it 'will return json scoped to specified times' do
      actions = @client.actions
      actions.should be_a Array
      actions.first.should be_a Wakatime::Models::Action
      actions.first.should respond_to :file
      actions.first.should respond_to :time
    end

    it 'will return current user json' do
      current_user = @client.current_user
      current_user.should be_a Wakatime::Models::User
      current_user.should respond_to :email
      current_user.should respond_to :timezone
    end

    it 'will return plugin usage json scoped to specified times' do
      plugins = @client.plugins
      plugins.should be_a Array
      plugins.first.should be_a Wakatime::Models::Plugin
      plugins.first.should respond_to :name
    end

    it 'will return daily json scoped to specified times' do
      daily = @client.daily
      daily.should be_a Array
      daily.first.should be_a Wakatime::Models::Summary
      daily.first.should respond_to :grand_total
      daily.first.should respond_to :projects
    end
  end
end
