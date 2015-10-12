# encoding: UTF-8

require 'spec_helper'
require 'support/account'
require 'wakatime'
require 'webmock/rspec'

describe Wakatime::Client do
  before do
    @session = Wakatime::Session.new
  end

  describe '#summaries' do
    it 'should return json' do
      stub_request(:get, "#{Wakatime::API_URL}/summaries")
      .with(query: hash_including(:start, :end))
      .to_return(body: File.read('./spec/fixtures/summaries.json'), status: 200)

      client = Wakatime::Client.new(@session)
      expect(client.summaries.grand_total.total_seconds).to eq 49_740

    end
  end

  describe '#heartbeats' do
    it 'should return json' do
      stub_request(:get, "#{Wakatime::API_URL}/heartbeats")
      .with(query: hash_including(:date))
      .to_return(body: File.read('./spec/fixtures/heartbeats.json'), status: 200)

      client = Wakatime::Client.new(@session)
      expect(client.heartbeats.last.time).to eq 1_422_631_940.699831

    end
  end
end
