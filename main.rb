require 'json'
require_relative 'Parser'
require_relative 'FieldAnalyzer'
require_relative 'Allocator'

def print_usage
  puts "Usage: ruby main.rb <input.json>"
  puts "  input.json  - Input JSON file with instruction formats"
  puts "  Output: result.json (always)"
  exit 1
end

def main
  if ARGV.empty?
    puts "Error: No input file specified"
    print_usage
  end

  input_file = ARGV[0]
  output_file = 'result.json'

  unless File.exist?(input_file)
    puts "Error: File '#{input_file}' not found"
    exit 1
  end

  unless input_file.end_with?('.json')
    puts "Warning: '#{input_file}' may not be a JSON file"
  end

  begin
    puts "Processing: #{input_file}"

    # parse JSON
    parser = CompileTest::InputParser.new(input_file)
    data = parser.parse

    # analyze formats
    analyzer = CompileTest::FieldAnalyzer.new(data)
    processed_formats = analyzer.process_instruction_struct

    # resolve fields
    resolver = CompileTest::BitAllocator.new(data, processed_formats)
    res_insns = resolver.resolve_fields

    # 4. write output
    File.write(output_file, JSON.pretty_generate(res_insns))
    puts "Output saved to #{output_file}"
    puts "Processed #{res_insns.size} instructions"

  rescue JSON::ParserError => e
    puts "JSON Parse Error: #{e.message}"
    exit 1
  rescue => e
    puts "Error: #{e.message}"
    puts e.backtrace.first(5) if ENV['DEBUG']
    exit 1
  end
end

main