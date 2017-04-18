# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver do
    no "MyString"
    name "MyString"
    sex "MyString"
    age 1
    tel "MyString"
    team_id 1
    default_car_id 1
  end
end
