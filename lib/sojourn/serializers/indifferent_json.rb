module Sojourn
  module Serializers
    class IndifferentJSON
      def self.load(string)
        JSON.parse(string || '{}').with_indifferent_access
      end

      def self.dump(hash)
        (hash || {}).to_json
      end
    end
  end
end
