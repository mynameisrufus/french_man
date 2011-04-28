require 'deep_merge'

class FrenchMan
  VERSION = "0.0.1"

  #@@blueprints = {}
  
  def self.const_missing(name)
    clazz = Class.new
    clazz.instance_eval do
      def blueprint(&block)
        blueprint = Blueprint.new &block
        self.send(:class_variable_set, :@@blueprint, blueprint)
      end

      def plan(&block)
        plan = Plan.new &block
        self.send(:class_variable_get, :@@blueprint).merge plan.hash
      end
    end
    self.const_set name, clazz
  end

  # Constructs a blueprint for future use
  #
  # Example:
  #   FrenchMan.blueprint {
  #     name { 'francois' }
  #     password { 'baguette' }
  #   }
  #
  #def self.blueprint(name, &block)
  #  @@blueprints[name] = Blueprint.new &block
  #end
  
  # Create a new hash from a blueprint
  #   
  #     vinos { [Vino.new("Grenache"), Vino.new("Merlot")] }
  #def self.plan(name, &block)
  #  blueprint = @@blueprints[name]
  #  raise "blueprint #{name} is not defined" if blueprint.nil?
  #  plan = Plan.new &block
  #  blueprint.merge plan.hash
  #end
  
  class Plan
    attr_reader :hash

    def initialize(&block)
      @hash = {}
      instance_eval &block unless block.nil?
    end

    def method_missing(attribute, &block) #:nodoc:
      @hash.merge!(attribute => block.call)
    end
  end

  class Blueprint
    def initialize(&block)
      @hash = {}
      instance_eval &block
    end

    def merge(plan)
      attribute_names = @hash.keys - plan.keys
      attribute_names.each do |attribute_name|
        value = @hash[attribute_name]
        plan[attribute_name] = value.respond_to?(:call) ? value.call : value
      end
      plan
    end

    def method_missing(attribute, &block) #:nodoc:
      @hash.merge!(attribute => block)
    end
  end
end
