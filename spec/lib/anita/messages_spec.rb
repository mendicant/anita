require_relative "../../spec_helper"

describe Anita::Messages do
  before do
    Anita::Messages.destroy
  end

  let(:channel)   { "#cinch-bots" }
  let(:nick)      { "test-bot"    }
  let(:text)      { "hello world" }
  let(:timestamp) { Time.now.utc.to_datetime }

  subject{ Anita::Messages.create(channel: channel, nick: nick, text: text) }

  its(:timestamp){ should eq(timestamp) }
  its(:humanized_timestamp){ should eq("2012-01-01 00:00:00 UTC") }
end
