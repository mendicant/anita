require "sinatra/base"
require "date"
require "json"
require "haml"

require_relative "../config/environment"
require_relative "../lib/anita"

class AnitaWeb < Sinatra::Base
  configure do
    mime_type(:markdown, "text/plain")
    Anita.start_db
  end

  get("/") do
    "Oh hai, I'm Anita :]"
  end

  get("/:channel/:from..:to.:format") do
    render_transcript(params)
  end

  get("/:channel/:from..:to", provides: "html") do
    render_transcript(params)
  end

  private

  def render_transcript(options)
    channel = "##{options[:channel]}"
    from    = options[:from]
    to      = options[:to]
    format  = format_for(options[:format] || "html")

    transcript = Anita::Transcripts.load(channel, from, to)

    case format
    when :html
      haml(:transcript, locals: {transcript: transcript})
    when :json
      transcript.to_json
    when :markdown
      erb(:transcript, locals: {transcript: transcript})
    else
      raise Sinatra::NotFound
    end
  end

  def format_for(ext)
    case ext
    when "html"
      :html
    when "json", "js"
      :json
    when "markdown", "md"
      :markdown
    else
      :unknown
    end
  end
end
