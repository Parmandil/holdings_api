class HoldingResource < JSONAPI::Resource
  attributes :cusip, :description, :par_value, :coupon, :maturity, :sector,
    :quality, :price, :accrued, :currency, :market_value, :weight, :yield, :dur,
    :cov, :oas, :sprd_dur, :pd
end
