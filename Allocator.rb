module CompileTest
  class BitAllocator

    attr_reader :data_completed, :processed_formats

    def initialize(data_completed, processed_formats)
      @length = data_completed['length']
      @instructions = data_completed['instructions']
      @processed_formats = processed_formats
    end

    def resolve_fields
      return 0 if @instructions.size == 0 

      res_insns = []

      f_bits_size = Math.log2(@instructions.size).ceil

      @instructions.each_with_index do |format, f_index|
        format_name = format['format'].to_sym
        opcode_bits_size = Math.log2(format['insns'].size).ceil

        f_bits = f_index.to_s(2).rjust(f_bits_size, '0')
        format['insns'].each_with_index do |insn_name, opcode|
          res_insns << {
            insn: insn_name,
            format: format_name,
            fields: @processed_formats[format_name].transform_values(&:dup)
          }

          if res_insns.last[:fields][:f_bits]
            res_insns.last[:fields][:f_bits][:value] = f_bits
          end

          if res_insns.last[:fields][:opcode_bits]
            res_insns.last[:fields][:opcode_bits][:value] = 
              opcode.to_s(2).rjust(opcode_bits_size, '0')
          end
        end
      end

      res_insns
    end
  end
end
