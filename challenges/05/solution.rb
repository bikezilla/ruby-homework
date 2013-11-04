module Enumerable

  def split_up(length:, step: length, pad: [])
    each_slice(step).map do |slice|
      line = (slice | pad).take(length)

      block_given? ? (yield line) : line
    end
  end

end
