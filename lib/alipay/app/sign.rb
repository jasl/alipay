module Alipay
  module App
    module Sign
      ALIPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCQwpCPC4oB+clYNBkKQx3gfyFl
Ut3cpRr5oErt OypLKh6j1UmTDSpfsac29h1kC0HIvLmxWbPuoxcsKDlclgRPeWn
IxrpSF9k5Fu6SRy3+AOdIKrDO SHQ7VwUsNih2OnPbztMSMplGnQCBa1iec2r+38
Udmh5Ua2xg6IEfk493VQIDAQAB
-----END PUBLIC KEY-----
      EOF

      def self.generate(params, options = {})
        params = Utils.stringify_keys(params)
        key = options[:key] || Alipay.key
        string = params_to_string(params)

        RSA.sign(key, string)
      end

      def self.verify?(params, options = {})
        params = Utils.stringify_keys(params)
        sign = params.delete('sign')
        string = async_notify_params_to_string(params)

        ::Alipay::Sign::RSA.verify?(ALIPAY_RSA_PUBLIC_KEY, string, sign)
      end

      # 异步通知返回的数据的签名字串与API调用和同步通知返回的结果不同
      def self.async_notify_params_to_string(params)
        params.sort.map do |key, value|
          "#{key}=#{value}"
        end.join('&')
      end

      def self.params_to_string(params)
        params.sort.map do |key, value|
          "#{key}=\"#{value}\""
        end.join('&')
      end
    end
  end
end
