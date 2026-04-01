require_relative 'Parser'
require_relative 'Generator'
require_relative 'Allocator'

def main
  print "Enter JSON filename"
  json_f = gets.chomp

  if json_f.empty?
    puts "Error: JSON filename is empty"
    exit 1
  end

  parser = CompileTest::InputParser.new(json_f)
  data = parser.parse

end
