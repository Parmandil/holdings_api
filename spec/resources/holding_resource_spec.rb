require 'rails_helper'

describe HoldingResource, type: :request do 
  let(:headers) { { "Accept" => "application/vnd.api+json" } }

  describe "index" do
    before { 5.times { FactoryBot.create(:holding) } }

    subject { get "/holdings", headers: headers }

    it "returns 200" do
      subject
      expect(response.status).to eq(200)
    end

    it "returns all the holdings" do
      subject

      data = JSON.parse(response.body).dig('data')
      cusips_returned = data.map { |item| item.dig('attributes').dig('cusip') }

      expect(data.count).to eq(5)
      expect(cusips_returned).to match_array(Holding.pluck(:cusip))
    end

    it "contains data for each holding" do
      subject
      data = JSON.parse(response.body).dig('data')
      # Check a random attribute - if it's there, all should be there
      expect(data.first.dig('attributes').dig('coupon')).to be_present
    end
  end
end
