require_relative "./mars_rover"

puts "Enter Top(upper-right) coordinates of the plateau separated by spaces:"
upper_right_coordinate = gets

starting_position = []
instructions = []
inputs = []

for i in 0...2
  puts "Enter Rover's starting position(two integers and a letter) separated by spaces:"
  starting_position[i] = gets
  puts "Enter series of instructions for rover in the form of [L]eft [R]ight [M]ove:"
  instructions[i] = gets

  inputs.push({ 
    top_coordinates: upper_right_coordinate, 
    starting_position: starting_position[i], 
    instructions: instructions[i]
  })
end

inputs.each do |input|
  result = MarsRover.get_updated_rover_position input
  puts "Updated rover position: #{result}" if result.present?
end