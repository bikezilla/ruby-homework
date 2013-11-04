describe "Object.thread" do
  it "works with lambdas" do
    42.thread(->(x) { x / 2 }, ->(x) { x - 1 }).should eq 20
  end

  it "works with symbols" do
    42.thread(:succ, :odd?).should eq true
  end

  it "works with multiple operations" do
    "42".thread(:to_i, ->(x) { x / 6 }, :succ, ->(x) { x ** 2 }).should eq 64
  end

  it 'works with -42' do
    -42.thread(:abs, -> x { x ** 3 }, :succ, -> x { x - 2 }).should eq 74087
  end

  it 'works with Marvin' do
    "Marvin".thread(:size, -> x { x ** 4 }, :to_s, -> s { s.split "" }, -> a { a[0] + a[-1] }, :to_i).should eq 16
  end

  it 'works with no args' do
    42.thread().should eq 42
  end

  it 'works with Procs' do
    42.thread(Proc.new{ |x| x / 2 }, Proc.new{ |x| x - 1 }).should eq 20
  end

end
