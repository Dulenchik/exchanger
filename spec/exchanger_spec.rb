require "spec_helper"

module Exchanger
  describe CurrenciesRate do
    let(:exchange) { CurrenciesRate.new("ua", false) }
    context "public methods" do
      context "#initialize" do
        it "call #update_from method" do
          exchange.should_receive(:update_from).with("ua", true).once
          exchange.send(:initialize, "ua", true)
        end
      end

      context "#updated?" do
        it "return true if @rates is non-empty" do
          exchange.updated?.should be true
        end

        it "return false if @rates is empty" do
          exchange.update_from("usa")
          exchange.updated?.should be false
        end
      end

      context "using #update_from with correct parameters" do
        context "#update_from" do
          it "return hash" do
            exchange.update_from("ua").should be_kind_of(Hash)
          end

          it "response has keys of symbols" do
            exchange.instance_variable_get(:@rates).keys.should has_items_kind_of(Symbol)
          end

          it "call #connect method" do
            exchange.stub(:connect).and_return(Nokogiri::XML::Document.new)
            exchange.should_receive(:connect).with("ua", false).once
            exchange.update_from("ua", false)
          end
        end

        context "#get_information_about" do
          it "return hash" do
            exchange.get_information_about(:EUR).should be_kind_of(Hash)
          end

          it "return a non-empty hash" do
            exchange.get_information_about(:EUR).should_not be_empty
          end

          it "return nil if code is wrong" do
            exchange.get_information_about(:AAA).should be_nil
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd)
            exchange.get_information_about(:uSd)
          end
        end

        context "#get_name_of" do
          it "return name in english" do
            exchange.get_name_of(:USD, :en).should eql("US Dollar")
          end

          it "return name in russian" do
            exchange.get_name_of(:USD, :ru).should eql("Доллар США")
          end

          it "return name in ukrainian" do
            exchange.get_name_of(:USD, :ua).should eql("Долар США")
          end

          it "return nil if code is wrong" do
            exchange.get_name_of(:AAA, :ua).should be_nil
          end

          it "return nil if language is wrong" do
            exchange.get_name_of(:USD, :aa).should be_nil
          end

          it "return nil if code and language is wrong" do
            exchange.get_name_of(:AAA, :aa).should be_nil
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd)
            exchange.get_name_of(:uSd)
          end
        end

        context "#get_base_of" do
          it "return 'UA' for 'ua'" do
            exchange.update_from("ua", false)
            exchange.get_base_of(:USD).should eql "UA"
          end

          it "return 'RU' for 'ru'" do
            exchange.update_from("ru", false)
            exchange.get_base_of(:USD).should eql "RU"
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd)
            exchange.get_base_of(:uSd)
          end
        end

        context "#get_unit_cost_of" do
          it "return float value" do
            exchange.get_unit_cost_of("usd").should be_kind_of(Float)
          end

          it "value based on current exchange rates" do
            exchange.get_unit_cost_of("usd").should eql 7.993
          end

          it "return nil if code is wrong" do
            exchange.get_unit_cost_of("aaa").should be_nil
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd)
            exchange.get_unit_cost_of(:uSd)
          end
        end

        context "#get_all_currencies" do
          it "return hash" do
            exchange.get_all_currencies.should be_kind_of(Hash)
          end

          it "hash should have items" do
            exchange.get_all_currencies.should_not be_empty
          end
        end

        context "#get_date_of_update" do
          it "return time value" do
            exchange.get_date_of_update(:USD).should be_kind_of(Time)
          end

          it "return date of currencies` update" do
            exchange.get_date_of_update(:USD).to_s.should eql "2013-06-06 00:00:00 +0300"
          end

          it "return nil if code is wrong" do
            exchange.get_date_of_update(:AAA).should be_nil
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd)
            exchange.get_date_of_update(:uSd)
          end
        end

        context "#convert_from_base_to" do
          it "return float value" do
            exchange.convert_from_base_to(:USD, 1000).should be_kind_of(Float)
          end

          it "value based on current exchange rates" do
            exchange.convert_from_base_to(:USD, 1000).should be_within(0.2).of(125)
          end

          it "return nil if code is wrong" do 
            exchange.convert_from_base_to("AAA", 1000).should be_nil
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd)
            exchange.convert_from_base_to(:uSd, 1000)
          end
        end

        context "#convert_to_base_from" do
          it "return float value" do
            exchange.convert_to_base_from(:USD, 1000).should be_kind_of(Float)
          end

          it "value based on current exchange rates" do
            exchange.convert_to_base_from(:USD, 1000).should eql 7993.0
          end

          it "return nil if code is wrong" do 
            exchange.convert_to_base_from("AAA", 1000).should be_nil
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd)
            exchange.convert_to_base_from(:uSd, 1000)
          end
        end

        context "#convert" do
          it "return float value" do
            exchange.convert(:USD, 1000, :USD).should be_kind_of(Float)
          end

          it "value based on current exchange rates" do
            exchange.convert(:USD, 1000, :USD).should eql 1000.0
          end

          it "return nil if code is wrong" do 
            exchange.convert("AAA", 1000, :USD).should be_nil
          end

          it "call #transform method" do
            exchange.should_receive(:transform).with(:uSd).twice
            exchange.convert(:uSd, 1000, :uSd)
          end
        end
      end

      context "using #update_from with wrong parameters" do
        it "#update_from return empty hash if country is wrong" do
          exchange.update_from("en").should be_empty
        end

        context "all 'get_...' and 'convert...' methods return nil if country is wrong" do
          before(:each) { exchange.update_from("en") }
          
          it "#get_information_about return nil" do
            exchange.get_information_about("USD").should be_nil
          end

          it "#get_name_of return nil" do
            exchange.get_name_of("USD", :ua).should be_nil
          end

          it "#get_base_of return nil" do
            exchange.get_base_of("USD").should be_nil
          end

          it "#get_unit_cost_of return nil" do
            exchange.get_unit_cost_of("USD").should be_nil
          end

          it "#get_all_currencies return nil" do
          exchange.get_all_currencies.should be_nil
          end

          it "#get_date_of_update return nil" do
            exchange.get_date_of_update("USD").should be_nil
          end

          it "#convert_from_base_to return nil" do
            exchange.convert_from_base_to("USD", 1000).should be_nil
          end

          it "#convert_to_base_from return nil" do
            exchange.convert_to_base_from("USD", 1000).should be_nil
          end

          it "#convert return nil" do
            exchange.convert("USD", 1000, "USD").should be_nil
          end
        end
      end

      context "#show_like_table" do
        it "write in console simple table" do
          exchange.should_receive(:puts).at_least(:twice)
          exchange.show_like_table
        end
      end
    end

    context "private methods" do
      context "#transform" do
        it "converts a string to symbol in upcase" do
          exchange.send(:transform, "uSd").should eql :USD
        end

        it "converts a symbol to symbol in upcase also" do
          exchange.send(:transform, :uSd).should eql :USD
        end
      end

      context "#connect" do
        it "return Nokogiri::XML::Document" do
          exchange.send(:connect, "ua", false).should be_kind_of(Nokogiri::XML::Document)
        end
      end
    end
  end
end
