# Credit: https://kylecrum.wordpress.com/2009/07/19/mock-cookies-in-rails-tests-the-easy-way/

module Mocks
  class Cookie < Hash
    def [](name)
      super(name)
    end

    def []=(key, options)
      if options.is_a?(Hash)
        options.symbolize_keys!
      else
        options = { value: options }
      end
      super(key, options[:value])
    end

    def delete(key, _)
      super(key)
    end

    def permanent
      self
    end

    def signed
      self
    end
  end
end
