module Decorators
  class BaseDecorator < SimpleDelegator
    def initialize(object)
      super(object)
    end
    
    def self.decorate(object)
      new(object)
    end
    
    def self.decorate_collection(collection)
      collection.map { |obj| new(obj) }
    end
  end
end
