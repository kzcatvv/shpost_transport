# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car do
    no "MyString"
    car_number "MyString"
    car_type "MyString"
    team_id 1
    default_driver_id 1
  end
end
