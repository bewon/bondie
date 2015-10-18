require 'spec_helper'

describe Bondie::Issue do
  let(:issue) { Bondie::Issue.new(coupon: 0.0622, maturity_date: Date.parse('2016-08-22'), coupon_frequency: 4) }

  describe 'price' do
    it 'should return price for which bond should be bought to make given YTM' do
      price = issue.price(0.05156, Date.parse('2015-09-07'), fees: 0.0019)
      expect(price).to be_within(0.01).of(100.8)
    end
  end

  describe 'interest_payments' do
    it 'should return dates of interest payments' do
      dates = %w(2015-11-22 2016-02-22 2016-05-22 2016-08-22).map { |d| Date.parse(d) }
      expect(issue.interest_payments(Date.parse('2015-09-07'))).to match_array(dates)
    end
    it 'should return also from_date if it\'s one of the payments date' do
      date = Date.parse('2016-05-22')
      expect(issue.interest_payments(date)).to include(date)
    end
  end

  describe 'ytm' do
    it 'should calculate YTM for given date and price' do
      result = issue.ytm(Date.parse('2015-09-07'), price: 100.8, fees: 0.0019)
      expect(result).to be_within(0.0001).of(0.05156)
    end
  end
end