module compile_test

  # JSON struct:
  # length[ num  = one_instr_length ], 
  # fields[ fields_names : fields_size ], 
  # instructions[ insns[ insns_names ], operands[ fields_names ], format[ format_name ], comment[ useless ]]

  class FieldAnalyzer
    field = Struct.new(:name, :min_size, :exact_size, :is_global)
    instruction = Struct.new(:name, :format, :operands, :opcode_value)
    bit_layout = Struct.new(:field_name, :msb, :lsb, :fixed_value)

    