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
end
