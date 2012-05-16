require 'spec_helper'

describe FrenchMan do
  let(:resulting_blueprint) {
    {
      :username => 'francois',
      :password => 'baguette',
      :groceries => {
        :garlic => true,
        :vino => {
          :red => 'tempranillo',
          :white => 'sav'
        },
        :other_items => [
          {
            :name => 'one',
            :num => 1
          },
          {
            :name => 'two',
            :num => 2
          }
        ]
      }
    }
  }

  before do
    FrenchMan::Login.blueprint {
      username { 'francois' }
      password { 'baguette' }
    }

    FrenchMan::Grocery.blueprint {
      garlic { true }
    }

    FrenchMan::Vino.blueprint {
      red { 'tempranillo' }
      white { 'sav' }
    }

    FrenchMan::OtherItem.blueprint {
      name { 'one' }
      num { 1 }
    }

    FrenchMan::TestType.blueprint {
      type { 'test' }
    }
  end

  it "should build a hash using a dsl" do
    build = FrenchMan::Login.plan {
      groceries {
        FrenchMan::Grocery.plan {
          vino { FrenchMan::Vino.plan }
          other_items {
            [
              FrenchMan::OtherItem.plan,
              FrenchMan::OtherItem.plan {
                name { 'two' }
                num { 2 }
              }
            ]
          }
        }
      }
    }
    build.should == resulting_blueprint
  end

  it "should handle type in object" do
    test_type = FrenchMan::TestType.plan
    test_type[:type].should == 'test'
  end

  let(:shopping) {
    FrenchMan::Login.plan {
      groceries {
        FrenchMan::Grocery.plan {
          vino {
            FrenchMan::Vino.plan {
              red { "Syrah" }
              white { "Cabernet Sauvignon" }
            }
          }
          cheeses {
            ['Camembert', 'Crotin du Chavignol']
          }
        }
      }
    }
  }

  it "should return objectified hash objects" do
    shopping.groceries.vino.red.should == "Syrah"
    shopping[:groceries][:vino][:red].should == "Syrah"
  end

  it "should return objectified hash objects" do
    shopping.groceries.cheeses.should == ['Camembert', 'Crotin du Chavignol']
    shopping[:groceries][:cheeses].should == ['Camembert', 'Crotin du Chavignol']
  end

  it "should be able to use hash syntax for plan" do
    hash = FrenchMan::Login.plan :grocery => { :vino => { :red => "Syrah", :white => "Cabernet Sauvignon"} }
    hash.grocery.vino.red.should == "Syrah"
    hash[:grocery][:vino][:red].should == "Syrah"
  end
  
  it "should handle type in object for <= ruby 1.8.7" do
    test_type = FrenchMan::TestType.plan
    test_type[:type].should == 'test'
  end
end
