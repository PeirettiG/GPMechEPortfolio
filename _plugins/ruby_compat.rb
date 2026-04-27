# Liquid 4.x calls tainted?/untaint which were removed in Ruby 3.2+
# Restore them as no-ops for compatibility
unless nil.respond_to?(:tainted?)
  class Object
    def tainted?
      false
    end
    def untaint
      self
    end
  end
end
