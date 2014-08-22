require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it 'makes a successful transition', :vcr do
        token = Stripe::Token.create(
          :card => {
          :number => '4242424242424242',
          :exp_month => 3,
          :exp_year => 2019,
          :cvc => 314
          }
        ).id
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: 'a valid charge')
        expect(response.successful?).to be_truthy
      end

      it 'makes a unsucessful transition', :vcr do
        token = Stripe::Token.create(
          :card => {
          :number => '4000000000000002',
          :exp_month => 3,
          :exp_year => 2019,
          :cvc => 314
          }
        ).id
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: 'an invalid charge')
        expect(response.successful?).to be_falsey
      end

      it 'returns the error message', :vcr do
        token = Stripe::Token.create(
          :card => {
          :number => '4000000000000002',
          :exp_month => 3,
          :exp_year => 2019,
          :cvc => 314
          }
        ).id
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: 'an invalid charge')
        expect(response.error_message).not_to be_nil
      end
    end
  end
end
