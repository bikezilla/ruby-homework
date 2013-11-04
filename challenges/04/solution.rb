def partition(number)
  (0..(number / 2)).map do |i|
    [i, number - i]
  end
end