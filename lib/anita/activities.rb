module Anita
  module Activities
    InvalidDateString = StandardError.new

    def self.load(description)
      Anita::Storage::Statements::Activities::Load
        .execute("description" => description)
        .to_a
        .first
    end

    def self.create(description, channel, started_at, ended_at)
      description ||= ""
      description.strip!

      channel ||= ""
      channel.strip!

      errors = []

      if description == ""
        errors << "Invalid 'description'. Cannot be blank."
      elsif exists?(description)
        errors << "Invalid 'description'. Already exists" 
      end

      if channel.nil? || channel.strip == ""
        errors << "Invalid 'channel'. Cannot be blank."
      end

      begin
        started_at = normalize_date_string(started_at)
      rescue InvalidDateString
        errors << "Invalid 'started_at'."
      end

      begin
        ended_at = normalize_date_string(ended_at)
      rescue InvalidDateString
        errors << "Invalid 'ended_at'."
      end


      if errors.size == 0
        create_activity(description, channel, started_at, ended_at)
      end

      [errors.size, errors]
    end

    private

    def self.exists?(description)
      !self.load(description).nil?
    end

    def self.normalize_date_string(str)
      DateTime.parse(str).to_s
    rescue
      raise InvalidDateString
    end

    def self.create_activity(description, channel, started_at, ended_at)
      Anita::Storage::Statements::Activities::Create .execute(
        "description" => description,
        "channel"     => channel,
        "started_at"  => started_at,
        "ended_at"    => ended_at
      )
    end
  end
end
