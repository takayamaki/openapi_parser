require_relative '../../spec_helper'

RSpec.describe OpenAPIParser::Schemas::Components do
  context 'OpenAPI 3.1 features' do
    let(:root) { OpenAPIParser.parse(load_yaml_file('./spec/data/openapi_3_1/components_path_items.yaml'), { expand_reference: false }) }

    describe 'pathItems' do
      subject { root.find_object('#/components') }

      context 'with a literal Path Item Object entry' do
        it 'is parsed as a PathItem' do
          expect(subject.path_items['LiteralPathItem'].class).to eq OpenAPIParser::Schemas::PathItem
        end
      end

      context 'with a $ref entry pointing to another Path Item' do
        it 'is parsed as a Reference' do
          expect(subject.path_items['ReferencedPathItem'].class).to eq OpenAPIParser::Schemas::Reference
        end
      end
    end
  end
end
