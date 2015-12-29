# Credit: https://kylecrum.wordpress.com/2009/07/19/mock-cookies-in-rails-tests-the-easy-way/

class Cookie < Hash
  def [](name)
    super(name.to_s)
  end

  def []=(key, options)
    if options.is_a?(Hash)
      options.symbolize_keys!
    else
      options = { value: options }
    end
    super(key.to_s, options[:value])
  end

  def delete(key, opts)
    super(key)
  end

  def permanent
    self
  end

  def signed
    self
  end
end
