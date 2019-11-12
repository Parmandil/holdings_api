require 'rails_helper'

describe HoldingResource, type: :request do
  let(:headers) { { "Accept" => "application/vnd.api+json" } }
  let(:holding) { Holding.last }
  let(:data) { JSON.parse(response.body).dig('data') }

  before do
    5.times { FactoryBot.create(:holding) }
  end

  describe "index" do
    subject { get "/holdings", headers: headers }
    before { subject }

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

    context "with a sort param" do
      subject { get "/holdings", params: { sort: sort_string }, headers: headers }

      let(:sort_string) { 'market-value' }

      it "sorts the results" do
        market_values = data.map do |item|
          item.dig('attributes').dig('market-value').to_f
        end
        expect(market_values).to eq(market_values.sort)
      end
    end
  end

  describe "show" do
    subject { get "/holdings/#{holding.id}", headers: headers }
    before { subject }

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

  describe "create" do
    subject { post "/holdings", headers: headers, params: create_data }

    let(:headers) do
      {
        "Accept" => "application/vnd.api+json",
        "Content-Type" => "application/vnd.api+json"
      }
    end

    let(:holding_attributes) do
      FactoryBot.attributes_for(:holding).transform_keys do |key|
        key.to_s.gsub('_', '-')
      end
    end

    let(:create_data) do
      {
        "data": {
          "type": "holdings",
          "attributes": holding_attributes
        }
      }.to_json
    end

    it "returns 201" do
      subject
      expect(response.status).to eq(201)
    end

    it "creates a new holding" do
      expect { subject }.to change { Holding.count }.by(1)
    end

    it "successfully sets the data it sent over on the new holding" do
      subject
      expect(holding.cusip).to eq(holding_attributes['cusip'])
      expect(holding.description).to eq(holding_attributes['description'])
      expect(holding.par_value.to_f).to be_within(0.001).of(holding_attributes['par-value'])
      expect(holding.coupon.to_f).to be_within(0.001).of(holding_attributes['coupon'])
      expect(holding.maturity.to_i).to eq(holding_attributes['maturity'])
      expect(holding.sector).to eq(holding_attributes['sector'])
      expect(holding.quality).to eq(holding_attributes['quality'])
      expect(holding.price.to_f).to be_within(0.001).of(holding_attributes['price'])
      expect(holding.accrued.to_f).to be_within(0.001).of(holding_attributes['accrued'])
      expect(holding.currency).to eq(holding_attributes['currency'])
      expect(holding.market_value.to_f).to be_within(0.001).of(holding_attributes['market-value'])
      expect(holding.weight.to_f).to be_within(0.001).of(holding_attributes['weight'])
      expect(holding.yield.to_f).to be_within(0.001).of(holding_attributes['yield'])
      expect(holding.dur.to_f).to be_within(0.001).of(holding_attributes['dur'])
      expect(holding.cov.to_f).to be_within(0.001).of(holding_attributes['cov'])
      expect(holding.oas.to_f).to be_within(0.001).of(holding_attributes['oas'])
      expect(holding.sprd_dur.to_f).to be_within(0.001).of(holding_attributes['sprd-dur'])
      expect(holding.pd.to_f).to be_within(0.001).of(holding_attributes['pd'])
    end
  end

  describe "update" do
    subject { put "/holdings/#{holding.id}", headers: headers, params: update_data }

    let(:headers) do
      {
        "Accept" => "application/vnd.api+json",
        "Content-Type" => "application/vnd.api+json"
      }
    end

    let(:update_attributes) do
      {
        "maturity": 30000,
        "accrued": 2.2,
        "price": 105,
        "market-value": 10500
      }
    end

    let(:update_data) do
      {
        "data": {
          "type": "holdings",
          "id": "#{holding.id}",
          "attributes": update_attributes
        }
      }.to_json
    end

    def reset_holding
      holding.update(FactoryBot.attributes_for(:holding))
    end

    it "returns 200" do
      subject
      expect(response.status).to eq(200)
    end

    it "updates the selected attributes" do
      reset_holding
      expect(holding.maturity).not_to eq(30000)
      expect(holding.accrued).not_to eq(2.2)
      expect(holding.price).not_to eq(105)
      expect(holding.market_value).not_to eq(10500)
      subject
      holding.reload
      expect(holding.maturity).to eq(30000)
      expect(holding.accrued).to eq(2.2)
      expect(holding.price).to eq(105)
      expect(holding.market_value).to eq(10500)
    end

    it "does not update the other attributes" do
      reset_holding
      old_cusip = holding.cusip
      old_par_value = holding.par_value
      old_yield = holding.yield
      subject
      holding.reload
      expect(holding.cusip).to eq(old_cusip)
      expect(holding.par_value).to eq(old_par_value)
      expect(holding.yield).to eq(old_yield)
    end
  end

  describe "delete" do
    subject { delete "/holdings/#{holding.id}", headers: headers }
    before { subject }

    it "returns 204" do
      expect(response.status).to eq(204)
    end

    it "doesn't include any body" do
      expect(response.body).to be_blank
    end

    it "deletes the holding" do
      expect(Holding.count).to eq(4)
      expect { Holding.find(holding.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    context "when the holding doesn't exist" do
      subject { delete "/holdings/#{holding.id + 1}", headers: headers }

      it "returns 404" do
        expect(response.status).to eq(404)
      end

      it "doesn't delete anything" do
        expect(Holding.count).to eq(5)
      end
    end
  end
end
