#encoding: UTF-8

require 'spec_helper'
require 'support/account'
require 'wakatime'
require 'webmock/rspec'

describe Wakatime, :skip => true do
  before do

    WebMock.allow_net_connect!

    @session = Wakatime::Session.new({
                                       api_key: ACCOUNT['api_key']
    })

    @client = Wakatime::Client.new(@session)

  end

  it "raises an AuthError if not client auth fails" do
    session = Wakatime::Session.new({
                                      api_key: 'bad-key'
    })

    @bad_client = Wakatime::Client.new(session)

    lambda {@bad_client.summary}.should raise_error( Wakatime::AuthError )
  end

  it "raises a RequestError if a badly formed request detected by the server" do
    stub_request(:get, "#{Wakatime::API_URL}/summary").to_return(:status => 401, :body => '{\n  \"errors\": [\n    \"UNAUTHORIZED\"\n  ]\n}', :headers => {})
    lambda {@client.summary}.should raise_error( Wakatime::AuthError )

    # make sure status and body is
    # set on error object.
    begin
      @client.summary
    rescue Exception => e
      e.body.should == '{\n  \"errors\": [\n    \"UNAUTHORIZED\"\n  ]\n}'
      e.status.should == 401
    end
  end

  it "raises a ServerError if the server raises a 500 error" do
    stub_request(:get, "#{Wakatime::API_URL}/summary").to_return(:status => 503, :body => '{"type": "error", "status": 503, "message": "We messed up!"}', :headers => {})
    lambda {@client.summary}.should raise_error( Wakatime::ServerError )

    # make sure status and body is
    # set on error object.
    begin
      @client.summary
    rescue Exception => e
      e.body.should == '{"type": "error", "status": 503, "message": "We messed up!"}' #TODO establish what happens when wakatime returns a 500 or something else. 
      e.status.should == 503
    end

  end

  describe Wakatime::Client do
    it "will return json scoped to specified times" do
      @client.summary.should include("data")
    end

    it "will return json scoped to specified times" do
      @client.actions.should include("data")
    end

    it "will return current user json" do
      @client.current_user.should include("data")
    end

    it "will return plugin usage json scoped to specified times" do
      @client.plugins.should include("data")
    end

    it "will return daily json scoped to specified times" do
      @client.daily.should include("data")
    end
  end
end
