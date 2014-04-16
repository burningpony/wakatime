#encoding: UTF-8

require 'spec_helper'
require 'support/account'
require 'wakatime'
require 'webmock/rspec'

describe Wakatime::Client do
  before do
    @session = Wakatime::Session.new
  end

  describe '#summary' do
    it "should return json" do
      Wakatime::Client.any_instance.should_receive(:summary).exactly(1).times
      client = Wakatime::Client.new(@session)
      client.summary
    end
  end
end
