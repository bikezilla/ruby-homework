module Enumerable

  def split_up(length:, step: length, pad: [])
    result = []

    self.each_slice(step) do |slice|
      line = slice.slice(0, length)
      line |= pad if line.size < length
      line = line.slice(0, length)

      result << line

      yield line if block_given?
    end

    result
  end

end
