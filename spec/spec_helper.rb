require "nokogiri"
require "open-uri"
require "exchanger"
require "fakeweb"
require "matchers"

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation

  config.before(:suite) do
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:get, "https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&apicour&country=ua&full",
                           :body => ("spec/fixtures/ua.xml"))
      FakeWeb.register_uri(:get, "https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&apicour&country=ru&full",
                           :body => ("spec/fixtures/ru.xml"))
      FakeWeb.register_uri(:get, "https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&apicour&country=ua",
                           :body => ("spec/fixtures/ua_small.xml"))
      FakeWeb.register_uri(:get, "https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&apicour&country=ru",
                           :body => ("spec/fixtures/ru_small.xml"))
    
  end
end