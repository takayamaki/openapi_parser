require_relative '../../../spec_helper'

RSpec.describe 'OpenAPIParser::SpecValidator::Rules::ExclusiveMaximum' do
  def schema_with_exclusive_maximum(openapi_version_string, exclusive_maximum_value, maximum_value: nil)
    schema_payload = { 'type' => 'integer', 'exclusiveMaximum' => exclusive_maximum_value }
    schema_payload['maximum'] = maximum_value if maximum_value
    raw = {
      'openapi' => openapi_version_string,
      'info' => { 'title' => 'test', 'version' => '1.0' },
      'paths' => {},
      'components' => { 'schemas' => { 'Sample' => schema_payload } },
    }
    OpenAPIParser.parse(raw, strict_reference_validation: false)
  end

  def run_rule_for(root)
    OpenAPIParser::SpecValidator::Rules::ExclusiveMaximum.new(root.openapi_version).check(root)
  end

  context 'with a 3.0 document using a 3.0-style boolean exclusiveMaximum' do
    it 'reports no violation'
  end

  context 'with a 3.1 document using a 3.1-style numeric exclusiveMaximum' do
    it 'reports no violation'
  end

  context 'with a 3.0 document using a 3.1-style numeric exclusiveMaximum' do
    it 'reports one violation pointing at the offending schema'
  end

  context 'with a 3.1 document using a 3.0-style boolean exclusiveMaximum' do
    it 'reports one violation pointing at the offending schema'
  end

  context 'with an :unknown version document containing exclusiveMaximum' do
    it 'reports no violation (rule skipped)'
  end

  context 'with a schema that has no exclusiveMaximum' do
    it 'reports no violation'
  end
end
