module OpenAPIParser
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
        []
      end
  end
end
