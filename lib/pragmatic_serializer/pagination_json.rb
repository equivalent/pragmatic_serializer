class PaginationJSON
  attr_reader :limit, :offset, :pagination_evaluator

  def initialize(limit:, offset:, pagination_evaluator:)
    @limit = limit
    @offset = offset
    @pagination_evaluator = pagination_evaluator
  end

  def as_json
    {
      limit: 10,
      offset: 0
    }
  end

  def first
  end

  def next

  end

  def prev

  end

  def href

  end
end
