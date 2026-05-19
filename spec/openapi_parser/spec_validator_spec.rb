require_relative '../spec_helper'

RSpec.describe 'OpenAPIParser::SpecValidator' do
  def parse_clean_root(version)
    raw = {
      'openapi' => version,
      'info' => { 'title' => 'test', 'version' => '1.0' },
      'paths' => {},
    }
    OpenAPIParser.parse(raw, strict_reference_validation: false)
  end

  describe '.run' do
    context 'with a root that has no spec-version-specific issues' do
      it 'returns an empty array' do
        root = parse_clean_root('3.0.0')
        expect(OpenAPIParser::SpecValidator.run(root)).to eq []
      end
    end

    context 'with a root whose openapi field is unrecognized' do
      it 'returns an empty array (version-specific rules are skipped)' do
        root = parse_clean_root('4.0.0')
        expect(OpenAPIParser::SpecValidator.run(root)).to eq []
      end
    end

    context 'with violations detected by a registered rule' do
      it 'returns the collected SpecViolation list' do
        raw = {
          'openapi' => '3.0.0',
          'info' => { 'title' => 'test', 'version' => '1.0' },
          'paths' => {},
          'components' => {
            'schemas' => {
              'Sample' => { 'type' => 'integer', 'exclusiveMinimum' => 5 },
            },
          },
        }
        root = OpenAPIParser.parse(raw, strict_reference_validation: false)
        violations = OpenAPIParser::SpecValidator.run(root)
        expect(violations.size).to eq 1
        expect(violations.first).to be_a(OpenAPIParser::SpecViolation)
      end
    end
  end
end

RSpec.describe 'OpenAPIParser parse with strict_specification_version' do
  let(:schema_with_30_doc_using_31_exclusive_minimum) do
    {
      'openapi' => '3.0.0',
      'info' => { 'title' => 'test', 'version' => '1.0' },
      'paths' => {},
      'components' => {
        'schemas' => {
          'Sample' => { 'type' => 'integer', 'exclusiveMinimum' => 5 },
        },
      },
    }
  end

  context 'when strict_specification_version is :silent (default)' do
    it 'parses without warning or raising even if violations exist'
  end

  context 'when strict_specification_version is :warn' do
    it 'parses but emits a warn for each violation'
  end

  context 'when strict_specification_version is :raise' do
    it 'raises OpenAPIParser::SpecViolationError carrying the violations'
  end
end
