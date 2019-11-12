require 'faker'

FactoryBot.define do
  factory :holding do
    cusip { Faker::Alphanumeric.unique.alphanumeric(number: 8) }
    description { Faker::Company.name }
    par_value { 10000 }
    coupon { force_non_negative(Faker::Number.normal(mean: 3.5, standard_deviation: 1.5)) }
    maturity { Faker::Number.between(from: 40000, to: 80000) }
    sector { 'IY' }
    quality { %w[ AAA AA1 AA+ AA2 AA AA3 AA- A1 A+ A2 A A3 A-
      BAA1 BBB+ BAA2 BBB BAA3 BBB- BA3 BB- NR ].sample }
    price { force_non_negative(Faker::Number.normal(mean: 100, standard_deviation: 12)) }
    accrued { rand()*2 }
    currency { 'USD' }
    market_value { par_value * price / 100.0 }
    weight { rand()*0.2 }
    add_attribute(:yield) { force_non_negative(Faker::Number.normal(mean: 3.5, standard_deviation: 1)) }
    dur { force_non_negative(Faker::Number.normal(mean: 9.5, standard_deviation: 6)) }
    cov { Faker::Number.normal(mean: 1.3, standard_deviation: 2.1) }
    oas { Faker::Number.normal(mean: 1, standard_deviation: 0.6) }
    sprd_dur { force_non_negative(Faker::Number.normal(mean: 9.5, standard_deviation: 6)) }
    pd { rand() * 2 }
  end
end

def force_non_negative(number)
  number < 0 ? 0 : number
end
