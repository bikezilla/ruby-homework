class Polynomial

  def initialize(constants)
    @constants = constants
    @power = constants.size - 1
  end

  def to_s
    return '0' if @constants.any? && @constants.all?(&:zero?)

    @constants.map.with_index do |constant, index|
      next if constant.zero?

      [get_sign(constant, index), get_coefficient(constant), get_monomial(index)].join
    end.compact.join(' ')
  end

  private

  def get_sign(constant, index)
    if constant < 0
      '- '
    elsif index.zero?
      ''
    else
      '+ '
    end
  end

  def get_coefficient(constant)
    constant.abs == 1 ? '' : constant.abs
  end

  def get_monomial(index)
    case (@power - index)
      when 0
        ''
      when 1
        'x'
      else
        "x^#{@power - index}"
    end
  end

end