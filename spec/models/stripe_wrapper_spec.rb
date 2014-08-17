require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it 'makes a successful transition', :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        token = Stripe::Token.create(
          :card => {
          :number => '4242424242424242',
          :exp_month => 3,
          :exp_year => 2019,
          :cvc => 314
          }
        ).id
        resp = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: 'a valid charge')
        expect(resp.amount).to eq(999)
        expect(resp.currency).to eq('usd')
      end
    end
  end
end
