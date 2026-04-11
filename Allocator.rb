module CompileTest

  # JSON struct:
  # length[ num  = one_instr_length ], 
  # fields[ fields_names : fields_size ], 
  # instructions[ insns[ insns_names ], operands[ fields_names ], format[ format_name ], comment[ useless ]]

  # I want to create a bit counter for every insn
  # In the beginning I will count how many bits it have. Than I will choose filed, which I could increase.
  # If there is no fields available to increase, I will create a reservation_field

  # First of all, I need to count sizes of every field, then process every instr
  
  class BitAllocator

    attr_reader :data, :processed_formats

    def initialize(data_completed)
      @length = data_completed['length']
      @instructions = data_completed['instructions']
      @processed_formats = processed_formats
    end

    def resolve_fields
      
    end
  end
end
