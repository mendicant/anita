require_relative "spec_helper"

describe AnitaWeb do
  before do
    Anita::Messages.destroy
  end

  let(:app){ AnitaWeb }

  describe "fetching transcripts", type: :request do
    let(:channel){ "#cinch-bots" }
    let(:nick)   { "test-bot"    }
    let(:text)   { "hello world" }

    let(:message){
      Anita::Messages.create(channel: channel, nick: nick, text: text)
    }

    let(:from){ "1900-01-01" }
    let(:to)  { "9999-12-31" }

    let(:url){ "/#{channel[1..-1]}/#{from}..#{to}" }

    context "as html" do
      subject{ get("#{url}.html") }

      its(:body){ should include("<h1>#{message.channel}</h1>")             }
      its(:body){ should include("<td>#{message.nick}</td>")                }
      its(:body){ should include("<td>#{message.text}</td>")                }
      its(:body){ should include("<td>#{message.humanized_timestamp}</td>") }
    end

    context "as json" do
      subject{ get("#{url}.json") }

      let(:json_data){ message.to_h.to_json }

      its(:body){ should include(json_data) }
    end

    context "as markdown" do
      subject{ get("#{url}.markdown") }

      its(:body){ should include("## #{message.channel}")            }
      its(:body){ should include("**#{message.nick}**")              }
      its(:body){ should include(message.text)                       }
      its(:body){ should include("*#{message.humanized_timestamp}*") }
    end
  end
end
