module PragmaticSerializer
  class PaginationJSON
    attr_reader :limit, :offset, :pagination_evaluator

    def initialize(limit:, offset:, pagination_evaluator:)
      @limit = limit
      @offset = offset
      @pagination_evaluator = pagination_evaluator
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
      pagination_evaluator.call(limit: limit, offset: offset + limit)
    end

    def prev
      prev_offset = offset < limit ? 0 : offset - limit        
      pagination_evaluator.call(limit: limit, offset: prev_offset) if offset > 0
    end

    def href
      pagination_evaluator.call(limit: limit, offset: offset)
    end
  end
end
