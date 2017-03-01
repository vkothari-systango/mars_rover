require_relative "./ruby_extension"

class MarsRover
  attr_accessor :top_coordinates, :starting_position, :instructions_s, :instructions, :starting_position_x, :starting_position_y, 
                :starting_orientation, :top_x, :top_y, :current_position_x, :current_position_y, :current_orientation, 
                :origin_x, :origin_y, :errors

  LEFT_ORIENTATION = {"N" => "W", "W" => "S", "S" => "E", "E" => "N"}
  RIGHT_ORIENTATION = {"N" => "E", "E" => "S", "S" => "W", "W" => "N"}

  # class methods
  class << self
    # this method is to initialize, validate and calculate the rover's position based on the user's input.
    def get_updated_rover_position rover_input
      mars_rover = MarsRover.new rover_input
      mars_rover.get_updated_rover_position
    end
  end

  # instance methods
  # initialize the user's input and set the variables to calculate result.
  def initialize rover_input = nil
    rover_input ||= {}  # in case of nil rover_input.

    self.top_coordinates = rover_input[:top_coordinates]
    self.starting_position = rover_input[:starting_position]
    self.instructions_s = rover_input[:instructions]

    # default values
    self.instructions = []
    self.origin_x, self.origin_y = 0, 0   # set the origin(lower coordinates) value of square.
    self.errors = []  # set all validation errors

    # calculate the position and set the variables values based on three type of inputs.
    calculate_positions
  end

  # this will set the value of top x and top y position value based on coordinates.
  def calculate_and_set_top_coordinates
    if self.top_coordinates.present?
      coordinates = self.top_coordinates.to_s.strip.split(/\s+/)

      self.top_x, self.top_y = coordinates[0].to_i, coordinates[1].to_i
    end
  end

  # this will set the value of starting x and starting y positions based on starting position string.
  def calculate_and_set_starting_position
    if self.starting_position.present?
      positions = self.starting_position.to_s.strip.split(/\s+/)

      self.current_position_x = self.starting_position_x = positions[0].to_i
      self.current_position_y = self.starting_position_y = positions[1].to_i
      self.current_orientation = self.starting_orientation = positions[2].to_s.upcase
    end

  end

  # this will remove any spaces amoung the instruction string and set the array to instructions.
  def calculate_instructions
    self.instructions = self.instructions_s.to_s.strip.gsub(/\s+/, "").split("") if self.instructions_s.present?
  end

  def calculate_positions
    self.calculate_and_set_top_coordinates
    self.calculate_and_set_starting_position
    self.calculate_instructions
  end

  def move_x_up
    self.current_position_x < self.top_x ? (self.current_position_x += 1) : self.invalid_traverse
  end

  def move_x_down
    self.current_position_x > self.origin_x ? (self.current_position_x -= 1) : self.invalid_traverse("LOW")
  end

  def move_y_up
    self.current_position_y < self.top_y ? (self.current_position_y += 1) : self.invalid_traverse
  end

  def move_y_down
    self.current_position_y > self.origin_y ? (self.current_position_y -= 1) : self.invalid_traverse("LOW")
  end

  def move_rover
    case self.current_orientation
    when "N"
      self.move_y_up
    when "E"
      self.move_x_up
    when "W"
      self.move_x_down
    when "S"
      self.move_y_down
    end
  end

  def update_left_orientation
    self.current_orientation = LEFT_ORIENTATION[self.current_orientation]
  end

  def update_right_orientation
    self.current_orientation = RIGHT_ORIENTATION[self.current_orientation]
  end

  def move_and_update_rover instruction
    case instruction.to_s.upcase
    when "L"
      self.update_left_orientation
    when "R"
      self.update_right_orientation
    when "M"
      self.move_rover
    end
  end

  def get_rover_current_position
    [self.current_position_x, self.current_position_y, self.current_orientation].join(" ")
  end

  # get result on the basis of user's input.
  def get_updated_rover_position
    if self.valid?
      self.instructions.each do |instruction|
        self.move_and_update_rover instruction
      end

      result = self.get_rover_current_position
    end

    if !self.validation_error_messages.empty?
      self.validation_error_messages.each do |message|
        puts message
      end

      result = nil
    end

    result
  end

  def validation_error_messages
    self.errors.uniq
  end

  # this method will check the validition of each values and return the boolean value.
  def valid?
    validate_top_coordinates
    validate_starting_position
    validate_instructions

    self.errors.empty?
  end

  protected
    def add_error message
      self.errors.add "** #{message} **"
    end

    def invalid_traverse side = "HIGH"
      if side == "LOW"
        self.add_error("Invalid traverse instruction. It went beyond the lower limit.")
      else
        self.add_error("Invalid traverse instruction. It went beyond the top limit.")
      end
    end

    # specific method to check validation of top coordinates value.
    def validate_top_coordinates
      self.add_error "Invalid Top coordinates" if self.top_x.to_i <= 0 || self.top_y.to_i <= 0
    end

    # specific method to check validation of starting position value.
    def validate_starting_position
      if self.starting_position.blank?
        self.add_error "Invalid starting position"
      else
        if (self.current_position_x < 0 || self.current_position_x > self.top_x.to_i) || (self.current_position_y < 0 || self.current_position_y > self.top_y.to_i)
          self.add_error "Invalid starting position, it doesn't lie within Top coordinates"
        end
      end

      if self.starting_orientation.blank? || !["N", "E", "W", "S"].include?(self.starting_orientation.to_s)
        self.add_error "Invalid starting position"
      end
    end

    # specific method to check validation of instructions value.
    def validate_instructions
      self.add_error "Invalid instructions" if self.instructions.empty? || self.instructions.any? { |i| !["L", "R", "M"].include?(i) }
    end
end