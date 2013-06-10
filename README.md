# Exchanger

Gem works with exchange rates of the National Bank of Ukraine and the Central Bank of The Russian Federation

## Installation

Add this line to your application's Gemfile:

    gem 'exchanger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exchanger

## Usage

### Public methods

  `update_from(country, full)` - get information of exchange rates in country

  `updated?` - get true if exchange rates are updated, else return false

  `get_information_about(code)` - get information about specific currency

  `get_name_of(code, language)` - get name of specific currency in English(:en), Russian(:ru) or Ukrainian(:ua)

  `get_base_of(code)` - get base country of rates

  `get_unit_cost_of(code)` - get unit cost of specific currency

  `get_all_currencies` - get information about all currncies

  `get_date_of_update(code)` - get date of update information about specific currency

  `show_like_table` - write in terminal simple table with information about all currencies

  `convert_from_base_to(code, value)` - convert value in base to value in specific currency

  `convert_to_base_from(code, value)` - convert value in specific to value in base currency
  
  `convert(code_initial, value_initial, code_final)` - convert value between two currencies


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
