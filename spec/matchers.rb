RSpec::Matchers.define :has_items_kind_of do |type|
  match do |array|
    result = true
    array.each { |item| result &= item.kind_of?(type) }
    result
  end
end