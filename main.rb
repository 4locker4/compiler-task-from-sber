require_relative 'Parser'
require_relative 'FieldAnalyzer'
require_relative 'Allocator'

def main
  print "Enter JSON filename: "
  input_file = gets.chomp

  if input_file.empty?
    puts "Error: JSON filename is empty"
    exit 1
  end

  print "Enter output filename [debug_dump.json]: "
  output_file = gets.chomp
  output_file = 'debug_dump.json' if output_file.empty?

  begin
    parser = CompileTest::InputParser.new(input_file)
    data = parser.parse

    analyzer = CompileTest::FieldAnalyzer.new(data)
    processed_formats = analyzer.process_instruction_struct

    File.write(output_file, JSON.pretty_generate(processed_formats))
    puts "JSON saved to #{output_file}"

  rescue => e
    puts "Error: #{e.message}"
    exit 1
  end
end

main