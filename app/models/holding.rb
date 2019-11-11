class Holding < ApplicationRecord
  validates :cusip, :description, :par_value, :coupon, :maturity, :sector,
    :quality, :price, :accrued, :currency, :market_value, :weight, :yield, :dur,
    :cov, :oas, :sprd_dur, :pd,
    presence: true

  validates :cusip, uniqueness: true
  validates :par_value, :coupon, :maturity, :price, :accrued, :market_value,
    :weight, :yield, :dur, :sprd_dur, :pd,
    numericality: { greater_than_or_equal_to: 0 }
  validates :cov, :oas, numericality: true

  # Nothing can be more than 100% of the portfolio
  validates :weight, numericality: { less_than_or_equal_to: 100 }

  # Not including any non-investment-grade bonds;
  # there are a limited set of meaningful ratings.
  validates :quality, inclusion: { in: %w[
    AAA AA1 AA+ AA2 AA AA3 AA- A1 A+ A2 A A3 A-
    BAA1 BBB+ BAA2 BBB BAA3 BBB- BA3 BB- NR
  ]}

  # This spreadsheet has only bonds in US Dollars.
  # I'm going to validate for that because if that were ever to change,
  # we'd have to add some code to handle currency conversion.
  validates :currency, inclusion: { in: %w[USD] }

  validate :market_value_calculations_match

  def market_value_calculations_match
    calc_market_value = price/100.0 * par_value

    unless match_within_percentage(calc_market_value, market_value)
      errors.add(:market_value, "doesn't match price * par value")
    end
  end

  def match_within_percentage(number1, number2, percent: 1)
    too_low = number1 < number2 * (1 - (0.01 * percent))
    too_high = number1 > number2 * (1 + (0.01 * percent))

    within_range = !(too_low || too_high)
  end
end
