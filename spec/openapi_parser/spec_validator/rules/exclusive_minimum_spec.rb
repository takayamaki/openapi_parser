require_relative '../../../spec_helper'

RSpec.describe 'OpenAPIParser::SpecValidator::Rules::ExclusiveMinimum' do
  def schema_with_exclusive_minimum(openapi_version_string, exclusive_minimum_value, minimum_value: nil)
    schema_payload = { 'type' => 'integer', 'exclusiveMinimum' => exclusive_minimum_value }
    schema_payload['minimum'] = minimum_value if minimum_value
    raw = {
      'openapi' => openapi_version_string,
      'info' => { 'title' => 'test', 'version' => '1.0' },
      'paths' => {},
      'components' => { 'schemas' => { 'Sample' => schema_payload } },
    }
    OpenAPIParser.parse(raw, strict_reference_validation: false)
  end

  context 'with a 3.0 document using a 3.0-style boolean exclusiveMinimum' do
    it 'reports no violation'
  end

  context 'with a 3.1 document using a 3.1-style numeric exclusiveMinimum' do
    it 'reports no violation'
  end

  context 'with a 3.0 document using a 3.1-style numeric exclusiveMinimum' do
    it 'reports one violation pointing at the offending schema'
  end

  context 'with a 3.1 document using a 3.0-style boolean exclusiveMinimum' do
    it 'reports one violation pointing at the offending schema'
  end

  context 'with an :unknown version document containing exclusiveMinimum' do
    it 'reports no violation (rule skipped)'
  end

  context 'with a schema that has no exclusiveMinimum' do
    it 'reports no violation'
  end
end
