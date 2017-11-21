class InputHandler

  require 'json'

  attr_reader :command_input,
              :parsed_plans

  def initialize 
    @command_input = []
  end

  def parse_plans (json)
    file = File.read(json)
    @parsed_plans = JSON.parse(file, :symbolize_names => true)
  end
  
  def parse_commands (input)
    lines = input.split("\n")
    lines.each do |line|
      command, *params, value = line.chomp.split(' ')
      supplier = params.first
      plan = params.last
      @command_input << {command: command.to_sym, supplier: supplier, plan: plan, value: value.to_i}
    end
  end
  
end