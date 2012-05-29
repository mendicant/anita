require_relative "../../spec_helper"
require "json"

describe Anita::Transcripts do
  before do
    Anita::Messages.destroy
  end

  let(:channel)  { "#cinch-bots" }
  let(:nick)     { "test-bot"    }
  let(:text)     { "hello world" }
  let(:timestamp){ Time.now.utc.to_datetime }

  context ".record" do
    it "saves the message" do
      expected   = Anita::Transcripts.record(channel, nick, text)
      transcript = Anita::Transcripts.load(channel, timestamp, timestamp)

      transcript.first.should eq(expected)
    end
  end

  context ".load" do
    before do
      Anita::Messages.create(channel: channel, nick: nick, text: text)
    end

    let(:message){
      Anita::Messages.first(
        timestamp: timestamp, channel: channel, nick: nick, text: text
      )
    }

    subject{ Anita::Transcripts.load(channel, timestamp, timestamp) }

    its(:channel){ should eq(channel) }

    it "retrieves the appropriate messages" do
      subject.first.should eq(message)
    end

    context "#to_json" do
      it "returns a json formatted transcript" do
        expected = JSON.parse(message.to_h.to_json)
        m = JSON.parse(subject.to_json).first

        m.should eq(expected)
      end
    end
  end
end
