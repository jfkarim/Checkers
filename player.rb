class Player

  attr_accessor :color, :grid_hash, :name

  def initialize(color)
    self.color = color
    self.grid_hash = create_grid_hash
    get_name
  end

  def get_name
    puts "New player. What is your name?"
    self.name = gets.chomp.downcase.capitalize
  end

  def create_grid_hash
    keys = (("A".."H").to_a * 8).sort.zip((1..8).to_a * 8).map { |key| key.join('') }

    vals = (0...8).to_a.each_with_object([]) do |row, array|
      8.times do |col| array << [row, col]
      end
    end

    return Hash[keys.zip(vals)]
  end

  def get_inputs
    puts "Please type in your move as such: a1 b2"
    move = []
    inputs = (gets.chomp.upcase).split(' ')

    inputs.each do |coord|
      coord =~ /[A-H][1-8]/ ? move << grid_hash[coord] : get_inputs
    end

#    get_inputs if move.length != 2

    move
  end

end

test = Player.new('black')
puts "color:"
p test.color
puts "testing get_name"
p test.name
puts "testing grid_hash"
p test.grid_hash
puts "testing get_inputs"
p test.get_inputs