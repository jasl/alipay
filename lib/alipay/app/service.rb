module Alipay
  module MobileService
    GATEWAY_URL = 'https://mapi.alipay.com/gateway.do'

    SDK_PAY_ORDER_REQUIRED_OPTIONS = %w( partner notify_url out_trade_no subject total_fee body )
    def self.sdk_pay_order_info(options)
      options = {
        'service'        => 'mobile.securitypay.pay',
        '_input_charset' => 'utf-8',
        'partner'        => Alipay.pid,
        'payment_type'   => '1'
      }.merge(Utils.stringify_keys(options))

      Alipay::Service.check_required_options(options, SDK_PAY_ORDER_REQUIRED_OPTIONS)

      query_string(options)
    end

    def self.query_string(options)
      options.merge(
        'sign_type' => 'RSA',
        'sign' => CGI.escape(Alipay::MobileSign.generate(options))
      ).map do |key, value|
        "#{key}=\"#{value}\""
      end.join('&')
    end
  end
end
