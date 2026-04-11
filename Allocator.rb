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

    attr_reader :data_completed, :processed_formats

    def initialize(data_completed, processed_formats)
      @length = data_completed['length']
      @instructions = data_completed['instructions']
      @processed_formats = processed_formats
      @res_insns = []
    end

    def resolve_fields
      return if @instructions.size == 0 
      f_bits_size = Math.log2(@instructions.size).ceil

      @instructions.each_with_index do |format, f_index|
        format_name = format['format'].to_sym
        opcode_bits_size = Math.log2(format['insns'].size).ceil

        f_bits = f_index.to_s(2).rjust(f_bits_size, '0')
        format['insns'].each_with_index do |insn_name, opcode|
          @res_insns << {
            insn: insn_name,
            format: format_name,
            fields: @processed_formats[format_name].transform_values(&:dup)
          }

          @res_insns.last[:fields][:f_bits][:value] = f_bits

          if @res_insns.last[:fields][:opcode_bits]
            @res_insns.last[:fields][:opcode_bits][:value] = 
              opcode.to_s(2).rjust(opcode_bits_size, '0')
          end
        end
      end

      @res_insns
    end
  end
end
