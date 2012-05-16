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
  VERSION = "0.0.2"

  def self.const_missing(name) #:nodoc:
    clazz = Class.new do
      def self.blueprint(&block) 
        blueprint = Blueprint.new &block
        send(:class_variable_set, :@@blueprint, blueprint)
      end

      def self.plan(hash = nil, &block)
        blueprint = send(:class_variable_get, :@@blueprint)
        raise "blueprint is missing" if blueprint.nil?
        plan = hash.nil? ? Plan.new(&block) : HashBuild.new(hash)
        blueprint.merge plan.hash
      end
    end
    self.const_set name, clazz
  end
  
  class HashBuild
    def initialize(hash)
      @hash = hash || {}
    end

    def hash
      result = {}
      @hash.each_pair do |key, value|
        if FrenchMan.const_defined? key.capitalize
          blueprint = FrenchMan.const_get key.capitalize
          result.merge! key => blueprint.plan(value)
        else
          result.merge! key => value
        end
      end
      ObjectifiedHash.new result
    end
  end

  # Creates a new plan hash for merging with a blueprint
  class Plan
    undef_method :id if method_defined?(:id)

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
    undef_method :id if method_defined?(:id)
    undef_method :type if method_defined?(:type)

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
  
  class ObjectifiedHash
    undef_method :id if method_defined?(:id)
    undef_method :==, :===, :=~

    def initialize(attributes = {}) #:nodoc:
      @attributes = attributes
    end

    def method_missing(name, *args) #:nodoc:
      if @attributes.has_key? name
        value = name.is_a?(Hash) ? self.class.new(@attributes[name]) : @attributes[name]
      else
        @attributes.send name, *args
      end
    end
  end
end
