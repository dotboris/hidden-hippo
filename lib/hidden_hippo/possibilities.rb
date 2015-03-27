module HiddenHippo
  # Represents multiple possible values
  #
  # Each possible value has a support count. Adding possible values is done with #<<.
  # Retrieving the support count for a possible value is done with #[].
  class Possibilities
    include Enumerable

    class << self
      def demongoize(doc)
        HiddenHippo::Possibilities.new doc
      end

      def mongoize(value)
        case value
          when Possibilities then value.mongoize
          else value
        end
      end

      def evolve(value)
        case value
          when Possibilities then value.mongoize
          else value
        end
      end

      def resizable?
        true
      end
    end

    def initialize(counts={})
      @counts = counts
      @counts.keep_if {|_, c| c.kind_of?(Integer)}
      @counts.default_proc = proc {0}
    end

    def [](value)
      @counts[value]
    end

    def <<(value)
      @counts[value.to_s.gsub('.', '_')] += 1
    end

    def each(&block)
      @counts.sort_by{|c| - c.last}.map(&:first).each &block
    end

    def each_with_support(&block)
      @counts.sort_by{|c| - c.last}.each &block
    end

    def mongoize
      @counts
    end

    def resizable?
      Possibilities.resizable?
    end
  end
end