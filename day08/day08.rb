input = File.read("input.txt").chomp

digits = input.split("").map(&:to_i)

width = 25
height = 6

rows = digits.each_slice(width).to_a
layers = rows.each_slice(height).to_a

# part 1

layer = layers.min_by do |layer|
  layer.flatten.count(0)
end

pixels = layer.flatten
p pixels.count(1) * pixels.count(2)


# part 2
image = []

height.times do |row|
  image_row = []
  image << image_row
  width.times do |col|
    layers.each do |layer|
      pixel = layer[row][col]
      if pixel != 2
        pix = pixel == 0 ? ' ' : '█'
        image_row << pix
        break
      end
    end
  end
  p image_row.join('')
end

