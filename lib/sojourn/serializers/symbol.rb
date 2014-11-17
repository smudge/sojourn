module Sojourn
  module Serializers
    class Symbol
      def self.load(string)
        string.to_sym
      end

      def self.dump(symbol)
        symbol.to_s
      end
    end
  end
end
