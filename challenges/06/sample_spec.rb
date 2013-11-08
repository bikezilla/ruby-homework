describe Polynomial do
  it "formats a simple polynomial" do
    expect(Polynomial.new([1, 0, 2]).to_s).to eq 'x^2 + 2'
  end

  it "formats a polynomial which contains negative and zero coefficients" do
    expect(Polynomial.new([-3, -4, 1, 0, 6]).to_s).to eq '- 3x^4 - 4x^3 + x^2 + 6'
  end

  it "returns 0 for polynomial with only zero coefficients" do
    Polynomial.new([0, 0, 0]).to_s.should eq '0'
  end

  it 'returns empty string for polynomial with empty coefficients' do
    Polynomial.new([]).to_s.should eq ''
  end
end
