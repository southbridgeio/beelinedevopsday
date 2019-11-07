FactoryBot.define do
  factory :paste do
    body { Faker::Book.title }
    request_info { Faker::Book.title }
    language { Paste.language.options.sample[1] }
    ttl_days { (0..90).to_a.sample }
  end
end
