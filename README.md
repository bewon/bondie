# Bondie

Bondie is a simple calculator for the bond properties.
It can calculate Yield To Maturity (YTM), interest payments dates or price based on YTM.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bondie'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bondie

## Usage

Calculation YTM based on price and date:

```ruby
issue = Bondie::Issue.new(coupon: 0.0622, maturity_date: Date.parse('2016-08-22'), coupon_frequency: 4)
issue.ytm(Date.parse('2015-09-07'), price: 100.8)
```

It will not count exact yield, but it will approximate it - you can set maximum approximation error by adding `approximation_error` parameter to the method.

You can also check interest payments dates:

```ruby
issue = Bondie::Issue.new(coupon: 0.0622, maturity_date: Date.parse('2016-08-22'), coupon_frequency: 4)
issue.interest_payments(Date.parse('2015-09-07'))
```

Currently it will not skip weekends or other days without bond quotations, so it can be inaccurate.

Also it's possible to check price on which it will generate given yield:

```ruby
issue = Bondie::Issue.new(coupon: 0.0622, maturity_date: Date.parse('2016-08-22'), coupon_frequency: 4)
issue.price(0.05156, Date.parse('2015-09-07'))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
