# encoding: utf-8

require 'spec_helper'

describe Github::Users::Keys, '#list' do
  let(:key_id) { 1 }
  let(:request_path) { "/user/keys" }

  before {
    subject.oauth_token = OAUTH_TOKEN
    stub_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
      to_return(:body => body, :status => status,
      :headers => {:content_type => "application/json; charset=utf-8"})
  }

  after { reset_authentication_for(subject) }

  context "resource found for an authenticated user" do
    let(:body) { fixture('users/keys.json') }
    let(:status) { 200 }

    it {should respond_to :all }

    it "should get the resources" do
      subject.list
      a_get(request_path).with(:query => { :access_token => "#{OAUTH_TOKEN}"}).
        should have_been_made
    end

    it_should_behave_like 'an array of resources' do
      let(:requestable) { subject.list }
    end

    it "should get keys information" do
      keys = subject.list
      keys.first.id.should == key_id
    end

    it "should yield to a block" do
      yielded = []
      result = subject.list { |obj| yielded << obj }
      yielded.should == result
    end
  end

  it_should_behave_like 'request failure' do
    let(:requestable) { subject.list }
  end

end # list
