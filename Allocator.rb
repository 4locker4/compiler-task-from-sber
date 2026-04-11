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

    attr_reader :data_completed

    def initialize(data_completed)
      @length = data_completed['length']
      @fields = data_completed['fields']
      @instructions = data_completed['instructions']
    end

    bit_layout = Struct.new(:field_name, :msb, :lsb, :fixed_value)

    def resolve_fields
      @instructions.each_with_index do |format, format_num|

        # Here we need to process format fields. We need to know exact size of every field


        format['insns'].each_with_index do |insn_name, opcode|

    