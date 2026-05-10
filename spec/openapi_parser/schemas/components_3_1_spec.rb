require_relative '../../spec_helper'

RSpec.describe OpenAPIParser::Schemas::Components do
  context 'OpenAPI 3.1 features' do
    let(:root) { OpenAPIParser.parse(load_yaml_file('./spec/data/openapi_3_1/components_path_items.yaml'), {}) }

    describe 'pathItems' do
      subject { root.find_object('#/components') }

      context 'with a literal Path Item Object entry' do
        it 'is parsed as a PathItem'
      end

      context 'with a $ref entry pointing to another Path Item' do
        it 'is parsed as a Reference'
      end
    end
  end
end
