require 'json'

module CompileTest
  class InputParser

    attr_reader :json_f

    def initialize(json_f)
      @json_f = json_f
    end

    def parse

      begin
        json_str = File.read(@json_f)
        data = JSON.parse(json_str)     
      rescue Errno::ENOENT
        raise "File not found #{@json_f}"
      end
    
    # In spec states that this is a fully valid JSON file. So there is no verification in JSON-format here #

      data
    end
  end
end
