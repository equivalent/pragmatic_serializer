module PragmaticSerializer
  class PaginationJSON
    attr_reader :limit, :offset, :pagination_evaluator
    attr_accessor :maximum_offset

    def initialize(limit:, offset:, pagination_evaluator:)
      @limit = limit
      @offset = offset
      @pagination_evaluator = pagination_evaluator
      @maximum_offset = Float::INFINITY
    end

    def as_json
      {
        limit: limit,
        offset: offset,
        href: href,
        first: first,
        next: self.next,
        prev: prev,
      }
    end

    def first
      pagination_evaluator.call(limit: limit, offset: 0)
    end

    def next
      pagination_evaluator.call(limit: limit, offset: offset+1) unless offset >= maximum_offset
    end

    def prev
      pagination_evaluator.call(limit: limit, offset: offset-1) if offset > 0
    end

    def href
      pagination_evaluator.call(limit: limit, offset: offset)
    end
  end
end
