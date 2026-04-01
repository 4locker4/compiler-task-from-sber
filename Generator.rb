module CompileTest

  # JSON struct:
  # length[ num  = one_instr_length ], 
  # fields[ fields_names : fields_size ], 
  # instructions[ insns[ insns_names ], operands[ fields_names ], format[ format_name ], comment[ useless ]]

  # I want to create a bit counter for every insn
  # In the beginning I will count how many bits it have. Than I will choose filed, which I could increase.
  # If there is no fields available to increase, I will create a reservation_field

  class FieldAnalyzer

    attr_reader :data

    def initialize(data)
      @length = data['length']
      @fields = data['fields']
      @instructions = data['instructions']
    end

    field = Struct.new(:name, :min_size, :exact_size, :is_global)
    instruction = Struct.new(:name, :format, :operands, :opcode_value)
    bit_layout = Struct.new(:field_name, :msb, :lsb, :fixed_value)

    