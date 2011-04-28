require 'deep_merge'

module FrenchMan
  class Baguette
    @@blueprints = {}

    def self.blueprint(name, &block)
      @@blueprints[name] = Blueprint.new &block
    end

    def self.plan(name, &block)
      blueprint = @@blueprints[name]

      #unless block.nil?
      blueprint.merge &block
      #else
      #  @@blueprints[name].m
      #end
    end
    
    class Blueprint
      def initialize(&block)
        @hash = {}
        @block = block
      end

      def merge(&block)
        instance_eval &@block
        unless block.nil?
          instance_eval &block 
        end
        @hash
      end

      def method_missing(attribute, &block) #:nodoc:
        @hash.merge!(attribute => block.call)
      end
    end
  end
end
