require_relative '../../../spec_helper'

RSpec.describe 'OpenAPIParser::SpecValidator::Rules::ExampleSingularDeprecation' do
  def schema_with_example(openapi_version_string, example_value, present: true)
    schema_payload = { 'type' => 'string' }
    schema_payload['example'] = example_value if present
    raw = {
      'openapi' => openapi_version_string,
      'info' => { 'title' => 'test', 'version' => '1.0' },
      'paths' => {},
      'components' => { 'schemas' => { 'Sample' => schema_payload } },
    }
    OpenAPIParser.parse(raw, strict_reference_validation: false)
  end

  def run_rule_for(root)
    OpenAPIParser::SpecValidator::Rules::ExampleSingularDeprecation.new(root.openapi_version).check(root)
  end

  context 'with a 3.0 document using singular example on a Schema' do
    it 'reports no violation'
  end

  context 'with a 3.1 document using singular example on a Schema' do
    it 'reports one violation pointing at the offending schema'
  end

  context 'with a 3.1 document that does not use singular example' do
    it 'reports no violation'
  end

  context 'with an :unknown version document' do
    it 'reports no violation (rule skipped)'
  end
end
