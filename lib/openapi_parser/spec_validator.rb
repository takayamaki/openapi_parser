require_relative 'spec_validator/spec_violation'
require_relative 'spec_validator/rule'
require_relative 'spec_validator/rules/exclusive_minimum'
require_relative 'spec_validator/rules/exclusive_maximum'

module OpenAPIParser
  # Raised when strict_specification_version is :raise and at least one
  # SpecViolation was collected.
  class SpecViolationError < OpenAPIError
    attr_reader :violations

    def initialize(violations)
      @violations = violations
      super(nil)
    end

    def message
      @violations.map(&:to_s).join("\n")
    end
  end

  # Validates that a parsed OpenAPI document is consistent with the version
  # it declares (3.0 vs 3.1). The parse layer is intentionally permissive;
  # this validator runs after parse and reports per-rule mismatches as
  # OpenAPIParser::SpecViolation values. Caller decides whether to warn,
  # raise, or ignore.
  class SpecValidator
    def self.run(root)
      new(root).run
    end

    def initialize(root)
      @root = root
      @version = root.openapi_version
    end

    def run
      rules.flat_map { |klass| klass.new(@version).check(@root) }
    end

    private

      def rules
        [
          Rules::ExclusiveMinimum,
          Rules::ExclusiveMaximum,
        ]
      end
  end
end
