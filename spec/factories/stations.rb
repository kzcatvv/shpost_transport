# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :station do
    no "MyString"
    name "MyString"
    address "MyString"
    tel "MyString"
    team_id 1
  end
end
