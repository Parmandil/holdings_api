require 'rails_helper'

describe HoldingResource, type: :request do
  let(:headers) { { "Accept" => "application/vnd.api+json" } }
  let(:holding) { Holding.last }
  let(:data) { JSON.parse(response.body).dig('data') }

  before do
    5.times { FactoryBot.create(:holding) }
    subject
  end

  describe "index" do
    subject { get "/holdings", headers: headers }

    it "returns 200" do
      expect(response.status).to eq(200)
    end

    it "returns all the holdings" do
      cusips_returned = data.map { |item| item.dig('attributes').dig('cusip') }

      expect(data.count).to eq(5)
      expect(cusips_returned).to match_array(Holding.pluck(:cusip))
    end

    it "contains data for each holding" do
      # Check a random attribute - if it's there, I'm not very worried the others won't be
      expect(data.first.dig('attributes').dig('coupon')).to be_present
    end
  end

  describe "show" do
    subject { get "/holdings/#{holding.id}", headers: headers }

    it "returns 200" do
      expect(response.status).to eq(200)
    end

    it "returns data about that holding" do
      expect(data.dig('attributes').dig('cusip')).to eq(holding.cusip)
      expect(data.dig('attributes').dig('description')).to eq(holding.description)
      expect(data.dig('attributes').dig('par-value').to_f).to be_within(0.001).of(holding.par_value)
      expect(data.dig('attributes').dig('coupon').to_f).to be_within(0.001).of(holding.coupon)
      expect(data.dig('attributes').dig('maturity').to_i).to eq(holding.maturity)
      expect(data.dig('attributes').dig('sector')).to eq(holding.sector)
      expect(data.dig('attributes').dig('quality')).to eq(holding.quality)
      expect(data.dig('attributes').dig('price').to_f).to be_within(0.001).of(holding.price)
      expect(data.dig('attributes').dig('accrued').to_f).to be_within(0.001).of(holding.accrued)
      expect(data.dig('attributes').dig('currency')).to eq(holding.currency)
      expect(data.dig('attributes').dig('market-value').to_f).to be_within(0.001).of(holding.market_value)
      expect(data.dig('attributes').dig('weight').to_f).to be_within(0.001).of(holding.weight)
      expect(data.dig('attributes').dig('yield').to_f).to be_within(0.001).of(holding.yield)
      expect(data.dig('attributes').dig('dur').to_f).to be_within(0.001).of(holding.dur)
      expect(data.dig('attributes').dig('cov').to_f).to be_within(0.001).of(holding.cov)
      expect(data.dig('attributes').dig('oas').to_f).to be_within(0.001).of(holding.oas)
      expect(data.dig('attributes').dig('sprd-dur').to_f).to be_within(0.001).of(holding.sprd_dur)
      expect(data.dig('attributes').dig('pd').to_f).to be_within(0.001).of(holding.pd)
    end

    context "when the holding doesn't exist" do
      subject { get "/holdings/#{holding.id + 1}", headers: headers }

      it "still returns 200" do
        expect(response.status).to eq(200)
      end

      it "doesn't return any data" do
        expect(data).to be_nil
      end
    end
  end
end
