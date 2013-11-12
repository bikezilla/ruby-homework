class Bitmap

  #there should be a function to get this ...
  LENGTH_BY_BASE = {2 => 8, 4 => 4, 16 => 2}

  def initialize(bytes, bytes_per_line = bytes.size)
    @bytes = bytes
    @bytes_per_line = bytes_per_line
  end

  def render(palette = ['.','#'])
    @bytes.each_slice(@bytes_per_line).map do |line|
      Bitmap.line_to_image(line, palette)
    end.join("\n")
  end

  def self.line_to_image(line, palette)
    line.map do |byte|
      base = palette.size

      byte_s = byte.to_s(base)
      full_byte = '0'*(LENGTH_BY_BASE[base] - byte_s.size) + byte_s

      Bitmap.byte_to_image(full_byte, palette)
    end.join
  end

  def self.byte_to_image(byte, palette)
    byte.chars.map do |c|
      palette[c.to_i]
    end
  end

end