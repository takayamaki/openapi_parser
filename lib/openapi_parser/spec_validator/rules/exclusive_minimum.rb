module OpenAPIParser
  class SpecValidator
    module Rules
      # In OpenAPI 3.0, exclusiveMinimum is a Boolean modifier on `minimum`.
      # In 3.1 it is a standalone numeric bound (and Boolean is no longer
      # valid). This rule flags documents that mix value-type and declared
      # version. :unknown versions are skipped.
      class ExclusiveMinimum < Rule
        def check(root)
          return [] if version == :unknown

          violations = []
          each_schema(root) do |schema|
            value = schema.exclusiveMinimum
            next if value.nil?

            case version
            when :v3_0
              if value.is_a?(Numeric) && !value.is_a?(TrueClass) && !value.is_a?(FalseClass)
                violations << violation(
                  path: schema.object_reference,
                  message: 'numeric exclusiveMinimum is a 3.1-only form; in 3.0 use a Boolean modifier paired with `minimum`',
                )
              end
            when :v3_1
              if value == true || value == false
                violations << violation(
                  path: schema.object_reference,
                  message: 'Boolean exclusiveMinimum is a 3.0-only form; in 3.1 use a standalone numeric bound',
                )
              end
            end
          end
          violations
        end
      end
    end
  end
end
