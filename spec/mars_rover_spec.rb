require 'spec_helper'

describe MarsRover do
  describe "Validations" do
    context "With blank values" do
      before :each do
        @mars_rover = MarsRover.new 
        @mars_rover.valid?
      end

      it "should have invalid top coordinates" do
        expect(@mars_rover.validation_error_messages).to include("** Invalid Top coordinates **")
      end

      it "should have invalid starting positions with blank records" do
        expect(@mars_rover.validation_error_messages).to include("** Invalid starting position **")
      end

      it "should have invalid instructions" do
        expect(@mars_rover.validation_error_messages).to include("** Invalid instructions **")
      end
    end

    context "With invalid values" do
      before :each do
        @mars_rover = MarsRover.new top_coordinates: "5 Test", 
                                    starting_position: "1 2 Test", 
                                    instructions: "TEST"
        @mars_rover.valid?
      end

      it "should have invalid top coordinates" do
        expect(@mars_rover.validation_error_messages).to include("** Invalid Top coordinates **")
      end

      it "should have invalid starting positions" do
        expect(@mars_rover.validation_error_messages).to include("** Invalid starting position **")
      end

      it "should have invalid instructions" do
        expect(@mars_rover.validation_error_messages).to include("** Invalid instructions **")
      end
    end

    context "With beyond the limit" do
      it "should have invalid starting positions beyond the limit based on inputs" do
        @mars_rover = MarsRover.new top_coordinates: "5 5", 
                                    starting_position: "5 6 N", 
                                    instructions: "LRLRM"
        @mars_rover.valid?

        expect(@mars_rover.validation_error_messages).to include("** Invalid starting position, it doesn't lie within Top coordinates **")
      end 

      it "should have invalid starting positions beyond the limit based on instructions" do
        @mars_rover = MarsRover.new top_coordinates: "5 5", 
                                    starting_position: "4 4 N", 
                                    instructions: "LRLRMMM"
        @mars_rover.valid? && @mars_rover.get_updated_rover_position
        
        expect(@mars_rover.validation_error_messages).to include("** Invalid traverse instruction. It went beyond the top limit. **")
      end 
    end
  end

  describe "with Valid values" do
    before :each do
      @mars_rover = MarsRover.new top_coordinates: "5 5", 
                                    starting_position: "3 3 E", 
                                    instructions: "MMRMMRMRRM"

      @mars_rover.valid?
      @result = @mars_rover.get_updated_rover_position
    end

    it "should display the result" do
      expect(@result).to eq("5 1 E")
    end
  end
end