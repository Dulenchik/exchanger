require "exchanger/version"
require "nokogiri"
require "open-uri"

module Exchanger
  class CurrenciesRate
    def initialize(country = "ua", full = true)
      update_from(country, full)
    end

    def update_from(country = "ua", full = true)
      @rates = Hash.new
      if country == "ua" || country == "ru"
        connect(country, full).xpath('//exchangerate').each do |item|
          unless item['ccy'].nil?
            date = item['date'].split('.')
            @rates[item['ccy'].to_sym] = { :en => item['ccy_name_en'].strip,
                                            :ua => item['ccy_name_ua'].strip,
                                            :ru => item['ccy_name_ru'].strip,
                                            :base => item['base_ccy'],
                                            :buy => item['buy'].to_f,
                                            :unit => item['unit'].to_i,
                                            :date => Time.new(date[0], date[1], date[2]) }
          end
        end
      end
      @rates
    end

    def updated?
      !@rates.empty?
    end

    def get_information_about(code)
      key = transform(code)
      @rates[key] if @rates.has_key?(key)
    end

    def get_name_of(code, language = :ua)
      key = transform(code)
      @rates[key]["#{language}".downcase.to_sym] if @rates.has_key?(key)      
    end

    def get_base_of(code)
      key = transform(code)
      @rates[key][:base] if @rates.has_key?(key)
    end

    def get_unit_cost_of(code)
      key = transform(code)
      @rates[key][:buy] / ( 10000 * @rates[key][:unit] ) if @rates.has_key?(key)
    end

    def get_all_currencies
      @rates unless @rates.empty?
    end

    def get_date_of_update(code)
      key = transform(code)
      @rates[key][:date] if @rates.has_key?(key)
    end

    def show_like_table
      puts "-" * 34 + "\n| Code |#{"Cost of unit".center(18, " ")}| Base |\n" + "-" * 34
      @rates.each_key do |key|
        puts "| #{ key }  |#{ get_unit_cost_of(key).to_s.center(18, " ") }|#{ get_base_of(key).center(6, " ") }|"
      end
      puts "-" * 34
    end

    def convert_from_base_to(code, value)
      key = transform(code)
      value / get_unit_cost_of(key) if @rates.has_key?(key)
    end

    def convert_to_base_from(code, value)
      key = transform(code)
      value * get_unit_cost_of(key) if @rates.has_key?(key)
    end

    def convert(code_initial, value_initial, code_final)
      key_initial, key_final = transform(code_initial), transform(code_final)

      if @rates.has_key?(key_initial) && @rates.has_key?(key_final)
        amount = convert_to_base_from(key_initial, value_initial)
        convert_from_base_to(code_final, amount)
      end
    end

    private 
      def transform(code)
        "#{ code }".upcase.to_sym
      end

      def connect(country, full)
        Nokogiri::XML(open("https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&apicour&country=#{ country }#{ "&full" if full }"))
      end
  end
end
