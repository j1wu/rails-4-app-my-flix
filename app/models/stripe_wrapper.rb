module StripeWrapper
  class Charge
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    def self.create(options={})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        card: options[:card],
        description: options[:description]
      )
    end
  end
end
