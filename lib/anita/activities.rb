module Anita
  module Activities
    def self.load(description)
      Anita::Storage::Statements::Activities::Load
        .execute("description" => description)
        .to_a
        .first
    end
  end
end
