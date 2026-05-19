module OpenAPIParser
  class SpecValidator
    # A single OpenAPI spec-version inconsistency reported by a Rule.
    SpecViolation = Struct.new(:message, :path, :rule_name, keyword_init: true) do
      def to_s
        "[#{rule_name}] #{path}: #{message}"
      end
    end
  end

  # Re-exposed at the top level so callers can pattern-match without
  # nesting their case statements deep inside SpecValidator.
  SpecViolation = SpecValidator::SpecViolation
end
