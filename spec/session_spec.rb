# encoding: UTF-8

require 'spec_helper'
require 'support/account'
require 'wakatime'
require 'webmock/rspec'

describe Wakatime::Session do
  before do

    @session = Wakatime::Session.new(
                                       api_key: 'Lame Key'
    )

    @client = Wakatime::Client.new(@session)

  end

  it 'raises a RequestError if a badly formed request detected by the server' do
    stub_request(:get, /.*\/summaries.*/).to_return(status: 401, body: '{\n  \"errors\": [\n    \"UNAUTHORIZED\"\n  ]\n}', headers: {})
    expect { @client.summaries }.to raise_error(Wakatime::AuthError)

    # make sure status and body is
    # set on error object.
    begin
      @client.summaries
    rescue StandardError => e
      expect(e.body).to eq '{\n  \"errors\": [\n    \"UNAUTHORIZED\"\n  ]\n}'
      expect(e.status).to eq 401
    end
  end

  it 'raises a ServerError if the server raises a 500 error' do
    stub_request(:get, /.*\/summaries.*/)
    .to_return(status: 503, body: '{"type": "error", "status": 503, "message": "We messed up!"}', headers: {})
    expect { @client.summaries }.to raise_error(Wakatime::ServerError)

    # make sure status and body is
    # set on error object.
    begin
      @client.summaries
    rescue StandardError => e
      expect(e.body).to eq '{"type": "error", "status": 503, "message": "We messed up!"}' # TODO establish what happens when wakatime returns a 500 or something else.
      expect(e.status).to eq 503
    end

  end
end
