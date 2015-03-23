module HiddenHippo
  # Represents multiple possible values
  #
  # Each possible value has a support count. Adding possible values is done with #<<.
  # Retrieving the support count for a possible value is done with #[].
  class Possibilities
    include Enumerable

    def initialize
      @counts = Hash.new {0}
    end

    def [](value)
      @counts[value]
    end

    def <<(value)
      @counts[value] += 1
    end

    def each(&block)
      @counts.sort_by{|c| - c.last}.map(&:first).each &block
    end

    def each_with_support(&block)
      @counts.sort_by{|c| - c.last}.each &block
    end
  end
end