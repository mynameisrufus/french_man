require 'spec_helper'

describe FrenchMan::Baguette do
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
    FrenchMan::Baguette.blueprint(:login) {
      username { 'francois' }
      password { 'baguette' }
    }

    FrenchMan::Baguette.blueprint(:grocery) {
      garlic { true }
    }

    FrenchMan::Baguette.blueprint(:vino) {
      red { 'tempranillo' }
      white { 'sav' }
    }

    FrenchMan::Baguette.blueprint(:other_item) {
      name { 'one' }
      num { 1 }
    }
  end

  it "should build a hash using a dsl" do
    build = FrenchMan::Baguette.plan(:login) {
      groceries {
        FrenchMan::Baguette.plan(:grocery) {
          vino { FrenchMan::Baguette.plan(:vino) }
          other_items {
            [
              FrenchMan::Baguette.plan(:other_item),
              FrenchMan::Baguette.plan(:other_item) {
                name { 'two' }
                num { 2 }
              }
            ]
          }
        }
      }
    }
    puts build
    build.should == resulting_blueprint
  end

  it "should recursively merge a hash" do

    #to_merge = {
    #  :username => 'vivian',
    #  :groceries => {
    #    :other_items => [
    #      {
    #        :name => 'three',
    #        :id => 3
         # }
    #    ]
    #  }
    #}

    #merged = FrenchMan::Baguette.make(:login) { to_merge }

    #what_should_be = hash.dup
    #what_should_be[:username] = to_merge[:username]
    #what_should_be[:groceries][:other_items] = to_merge[:groceries][:other_items]

    #merged.should == what_should_be
  end
end
