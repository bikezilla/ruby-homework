describe "Bitmap" do
  it "renders bytes" do
    Bitmap.new([9, 32], 1).render.should eq <<-ASCII.strip
....#..#
..#.....
    ASCII
  end

  it "supports different palettes" do
    Bitmap.new([13, 2, 5, 1], 2).render(%w[. * x #]).should eq <<-ASCII.strip
..#*...x
..**...*
    ASCII
  end

  it 'renders bytes 1' do
    Bitmap.new([1, 10, 100]).render.should eq <<-ASCII.strip
.......#....#.#..##..#..
    ASCII
  end

  it 'renders bytes 2' do
    bitmap = Bitmap.new [1, 10, 100]
    bitmap.render(['+', '@']).should eq <<-ASCII.strip
+++++++@++++@+@++@@++@++
    ASCII
  end 

  it 'renders bytes 3' do
    bitmap = Bitmap.new [1, 11], 1
    bitmap.render(['.', '_', '+', '@']).should eq <<-ASCII.strip
..._
..+@
    ASCII
  end

end
