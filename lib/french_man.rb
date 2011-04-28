# Constructs blueprints and assembles plans and has long holidays
#
# Example usage:
#   FrenchMan::Login.blueprint {
#     username { Faker.name }
#     password { 'baguette' }
#   }
#
#
#   login = FrenchMan::Login.plan {
#     username { 'francois' }
#   }
#   
#   login.username
#   => 'francois'
# 
#   login.password
#   => 'baguette'
class FrenchMan
  VERSION = "0.0.1"

  def self.const_missing(name) #:nodoc:
    clazz = Class.new do
      def self.blueprint(&block) 
        blueprint = Blueprint.new &block
        send(:class_variable_set, :@@blueprint, blueprint)
      end

      def self.plan(&block)
        blueprint = send(:class_variable_get, :@@blueprint)
        raise "blueprint is missing" if blueprint.nil?
        plan = Plan.new &block
        blueprint.merge plan.hash
      end
    end
    self.const_set name, clazz
  end
  
  # Creates a new plan hash for merging with a blueprint
  class Plan
    attr_reader :hash

    def initialize(&block) #:nodoc:
      @hash = {}
      instance_eval &block unless block.nil?
    end

    def method_missing(attribute, &block) #:nodoc:
      @hash.merge!(attribute => block.call)
    end
  end

  # The blueprint to create hashes from
  class Blueprint
    def initialize(&block) #:nodoc:
      @hash = {}
      instance_eval &block
    end
    
    # takes a hash as an argument and merges it with a the blueprint
    # hash and returns the hash wrapped in an +ObjectifiedHash+ object
    def merge(plan)
      attribute_names = @hash.keys - plan.keys
      attribute_names.each do |attribute_name|
        value = @hash[attribute_name]
        plan[attribute_name] = value.respond_to?(:call) ? value.call : value
      end
      ObjectifiedHash.new plan
    end

    def method_missing(attribute, &block) #:nodoc:
      @hash.merge!(attribute => block)
    end
  end
  
  # Wraper for plan hashes so dot syntax can be used
  class ObjectifiedHash
    undef_method :==, :===, :=~

    def initialize(attributes = {}) #:nodoc:
      @attributes = attributes
    end

    def method_missing(name, *args) #:nodoc:
      if @attributes.has_key? name
        value = @attributes[name]
      else
        @attributes.send name, *args
      end
    end
  end
end
