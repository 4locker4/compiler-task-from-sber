require 'json'

#
# Global output_instruction array with output instructions
# Format = № in input_instruction array with size = input_instructions.size
# Opcode = № in insns array with size = insns.size
# Fields = Field.name with size = Field.data
# If we can, we will expand the fields size
#

module compile_test
  class InputParser

      # JSON struct:
      # length[ num  = one_instr_length ], 
      # fields[ fields_names : fields_size ], 
      # instructions[ insns[ insns_names ], operands[ fields_names ], format[ format_name ], comment[ useless ]]

    def parse(json_f)

      begin
        json_str = File.read(json_f)
        data = JSON.parse(json_str)     
      rescue Errno::ENOENT
        raise "File not found #{json_f}"
      end
    
    # In spec states that this is a fully valid JSON file. So there is no verification in JSON-format here #

      return data

    end
  end
end
