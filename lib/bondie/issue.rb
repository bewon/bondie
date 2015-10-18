module Bondie
  class Issue

    DEFAULT_APPROXIMATION_ERROR = 0.001

    def initialize(coupon: nil, maturity_date: nil, coupon_frequency: nil, approximation_error: DEFAULT_APPROXIMATION_ERROR)
      @coupon               = coupon
      @maturity_date        = maturity_date
      @coupon_frequency     = coupon_frequency
      @approximation_error  = approximation_error
    end

    def price(ytm, date, fees: 0)
      price_for_irr(irr_from_ytm(ytm), date, fees: fees)
    end

    def interest_payments(from_date)
      payments = []
      date = @maturity_date
      while date >= from_date
        payments << date
        date = date.prev_month(12/@coupon_frequency)
      end
      payments.sort
    end

    def ytm(date, price: 100, fees: 0)
      ytm_down, ytm_up = ytm_limits(price, date, fees: fees)
      approximate_ytm(ytm_down, ytm_up, price, date, fees: fees)
    end


    private

    def irr_from_ytm(ytm)
      (ytm/@coupon_frequency.to_f + 1) ** @coupon_frequency - 1
    end


    def approximate_ytm(ytm_down, ytm_up, price, date, fees: 0)
      approx_ytm = (ytm_up + ytm_down) / 2.0
      return approx_ytm if ((ytm_up - approx_ytm)/approx_ytm).abs <= @approximation_error
      p = price(approx_ytm, date, fees: fees)
      ytm_down, ytm_up = p < price ? [ytm_down, approx_ytm] : [approx_ytm, ytm_up]
      approximate_ytm(ytm_down, ytm_up, price, date, fees: fees)
    end

    def ytm_limits(price, date, fees: 0)
      ytm_up = 0.1
      ytm_up *= 10 while price(ytm_up, date, fees: fees) > price
      # IRR will be never lower than -1, so YTM should be never lower than -coupon_frequency (see irr_from_ytm)
      ytm_down = price(0, date, fees: fees) > price ? 0.0 : -@coupon_frequency.to_f
      [ytm_down, ytm_up]
    end

    def price_for_irr(irr, date, fees: 0)
      raise "Date is after maturity_date!" if date > @maturity_date
      last = date
      interest_payments(date).map do |payday|
        interest = @coupon * 100 * ((payday-last)/365)
        interest += 100 if payday == @maturity_date
        last = payday
        interest / ((1+irr) ** ((payday-date)/365))
      end.inject(:+) / (1+fees)
    end

  end
end