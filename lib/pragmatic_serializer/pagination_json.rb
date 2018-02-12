module PragmaticSerializer
  class PaginationJSON
    attr_reader :limit, :offset, :total, :pagination_evaluator

    def initialize(limit:, offset:, total: nil, pagination_evaluator:)
      @limit = limit
      @offset = offset
      @total = total
      @pagination_evaluator = pagination_evaluator
    end

    def as_json
      h = {
        limit: limit,
        offset: offset,
        href: href,
        first: first,
        next: self.next,
        prev: prev,
      }
      h.merge!(total: total) if total
      h
    end

    def first
      pagination_evaluator.call(limit: limit, offset: 0)
    end

    def next
      show_next = unless total.nil?
         total > (offset + limit)
      else
        true
      end

      pagination_evaluator.call(limit: limit, offset: offset + limit) if show_next
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
