def deal_into_new_stack(deck)
  deck.reverse
end

def cut(deck, n)
  deck[n..-1] + deck[0...n]
end

def deal_with_increment(deck, n)
  new_deck = Array.new(DECK_SIZE)
  DECK_SIZE.times do |i|
    new_deck[(i*n)%DECK_SIZE] = deck[i]
  end
  new_deck
end


shuffles = File.readlines("input.txt")

DECK_SIZE = 10_007
deck = (0...DECK_SIZE).to_a

shuffles.each do |shuffle|
  case shuffle
  when /deal with increment (\d+)/
    puts "dwi #{$1}"
    deck = deal_with_increment(deck, $1.to_i)
  when /cut (-?\d+)/
    puts "cut #{$1}"
    deck = cut(deck, $1.to_i)
  when /deal into new stack/
    puts "dns"
    deck = deal_into_new_stack(deck)
  end
end

p deck.index(2019)
