# You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

# However, they do remember a few key facts about the password:

# It is a six-digit number.
# The value is within the range given in your puzzle input.
# Two adjacent digits are the same (like 22 in 122345).
# Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
# Other than the range rule, the following are true:

# 111111 meets these criteria (double 11, never decreases).
# 223450 does not meet these criteria (decreasing pair of digits 50).
# 123789 does not meet these criteria (no double).
# How many different passwords within the range given in your puzzle input meet these criteria?

# Your puzzle input is 123257-647015.

count = 0

1.upto(9) do |d1|
  d1.upto(9) do |d2|
    d2.upto(9) do |d3|
      d3.upto(9) do |d4|
        d4.upto(9) do |d5|
          d5.upto(9) do |d6|
            nr = d1 * 100000 + d2 * 10000 + d3 * 1000 + d4 * 100 + d5 * 10 + d6
            count += 1 if nr >= 123257 && nr <= 647015 && (d1==d2 || d2==d3 || d3==d4 || d4==d5 || d5==d6)
          end
        end
      end
    end
  end
end

p count

# --- Part Two ---
# An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.

# Given this additional criterion, but still ignoring the range rule, the following are now true:

# 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
# 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
# 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
# How many different passwords within the range given in your puzzle input meet all of the criteria?

# Your puzzle input is still 123257-647015.


count = 0

1.upto(9) do |d1|
  d1.upto(9) do |d2|
    d2.upto(9) do |d3|
      d3.upto(9) do |d4|
        d4.upto(9) do |d5|
          d5.upto(9) do |d6|
            nr = d1 * 100000 + d2 * 10000 + d3 * 1000 + d4 * 100 + d5 * 10 + d6
            # scream!
            if nr >= 123257 && nr <= 647015 && ((d1 == d2 && d2 != d3) || (d1 != d2 && d2 == d3 && d3 != d4) || (d2 != d3 && d3 == d4 && d4 != d5) || (d3 != d4 && d4 == d5 && d5 != d6) || (d4 != d5 && d5 == d6))
              count += 1
            end
          end
        end
      end
    end
  end
end

p count
