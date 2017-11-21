class App

  require_relative 'input_handler'
  require_relative 'calculator'

  attr_reader :input_handler

  def initialize 
    @input_handler = InputHandler.new
    @calculator = Calculator.new
    @plans = @input_handler.parse_plans(ARGV.first)
  end

  input_handler = @input_handler

  def compare_tariffs(user_input)
    input_handler.parse_commands(user_input)
    process_commands(input_handler.command_input)
  end

  def process_commands(parsed_input)
    parsed_input.each do |line|
      case line[:command]
        when :price
          @calculator.calculate_prices(line[:value], @plans)
        when :usage
          @calculator.calculate_usage(line[:supplier], line [:plan], line[:value], @plans)  
        when :exit
          exit
        else
          puts "Command not recognised" 
      end
    end
  end

end