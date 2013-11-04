module Enumerable

  def split_up(length:, step: length, pad: [])
    result = []

    self.each_slice(step) do |slice|
      line = (slice | pad).slice(0, length)

      result << line

      yield line if block_given?
    end

    result
  end

end
