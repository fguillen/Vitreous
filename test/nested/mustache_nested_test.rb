require 'rubygems'
require 'test/unit'
require 'mustache'

class MustacheNestedTest < Test::Unit::TestCase
  def test_nested_section_with_same_member_name
    template = <<template
{{#mothers}}
{{name}}: {{#children}}{{name}}({{name}}) {{/children}}|
{{/mothers}}
template

    data = {
      "mothers" => [
        { :name => 'Mother1', :children => [ {:name => "Kid1"}, {:name => "Kid2"} ] },
        { :name => 'Mother2', :children => [ {:name => "Kid1"}, {:name => "Kid2"} ] }
      ]
    }

    assert_equal <<expected, Mustache.render(template, data)
Mother1: Kid1(Mother1) Kid2(Mother1) |
Mother2: Kid1(Mother2) Kid2(Mother2) |
expected
  end
end