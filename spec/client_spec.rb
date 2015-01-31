# encoding: UTF-8

require 'spec_helper'
require 'support/account'
require 'wakatime'
require 'webmock/rspec'

describe Wakatime::Client do
  before do
    @session = Wakatime::Session.new
  end

  describe '#summary' do
    it 'should return json' do
      stub_request(:get, "#{Wakatime::API_URL}/summary")
      .with(query: hash_including(:start, :end))
      .to_return(body: File.read('./spec/fixtures/summary.json'), status: 200)

      client = Wakatime::Client.new(@session)
      expect(client.summary.grand_total.total_seconds).to eq 49_740

    end
  end

  describe '#actions' do
    it 'should return json' do
      stub_request(:get, "#{Wakatime::API_URL}/actions")
      .with(query: hash_including(:start, :end))
      .to_return(body: File.read('./spec/fixtures/actions.json'), status: 200)

      client = Wakatime::Client.new(@session)
      expect(client.actions.last.time).to eq 1_422_631_940.699831

    end
  end
end
