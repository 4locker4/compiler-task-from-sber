module CompileTest
  class FieldAnalyzer

    attr_reader :data

    def initialize(data)
      @length = data['length'].to_i
      @fields = data['fields']
      @instructions = data['instructions']
    end

    def process_instruction_struct
      format_len = format_num_len()
      all_processed_formats = {}

      @instructions.each_with_index do |format, f_index|
      # Here we need to process format fields. We need to know exact size of every field
        opcode_len = opcode_num_len(format)
        operands_size = sum_operands_size(format['operands'])
        curr_instr_len = format_len + opcode_len + operands_size

        # if curr_instr_len < @length we will add the difference into last field, if we can
        processed_format = {}
        bit_counter = @length - 1

        if format_len > 0
          bit_counter = process_format_field(processed_format, format_len, bit_counter)
        end
        
        if opcode_len > 0
          bit_counter = process_opcode_field(processed_format, opcode_len, bit_counter)
        end
      
        curr_instr_len = process_oprnds_field(processed_format, format['operands'], curr_instr_len, bit_counter)

        if curr_instr_len < @length
          process_padding_field(processed_format, curr_instr_len)
        end

        all_processed_formats[format['format'].to_sym] = processed_format
      end

      all_processed_formats
    end

    def process_padding_field(processed_format, curr_instr_len)
      processed_format[:oprnds] << {
        oprnd_name: "RES0",
        msb: @length - curr_instr_len - 1,
        lsb: 0,
        value: "0" * (@length - curr_instr_len)
      }
    end

    def process_oprnds_field(processed_format, operands, curr_instr_len, bit_counter)
      processed_format[:oprnds] ||= []
      operands.each do |operand|
        size, curr_instr_len = get_oprnd_size(operand, curr_instr_len)

        processed_format[:oprnds] << {
          oprnd_name: operand,
          msb: bit_counter,
          lsb: bit_counter - size + 1,
          value: "+"
        }

        bit_counter -= size
      end

      curr_instr_len  # Return updated value
    end

    def get_oprnd_size(operand, curr_instr_len)
      operand_hash = @fields.find { |f| f.key?(operand) }
      raise "Unknown field: #{operand}" unless operand_hash

      size_str = operand_hash[operand]

      if size_str.start_with?('>=')
        base_size = size_str.gsub('>=', '').to_i

        # Calculate expansion
        if curr_instr_len < @length
          extra_bits = @length - curr_instr_len
          base_size += extra_bits
          curr_instr_len = @length
        end

        [base_size, curr_instr_len]  # Return both
      else
        size = size_str.to_i
        [size, curr_instr_len]
      end
    end

    # I put this into separated function, because if we need to process it 
    # any other ways, it will be very helpful
    def process_format_field(processed_format, format_len, bit_counter)
      processed_format[:f_bits] = {
          name: "F",
          msb: bit_counter,
          lsb: bit_counter - format_len + 1,
          value: nil
      }

      bit_counter - format_len
    end

    def process_opcode_field(processed_format, opcode_len, bit_counter)
      processed_format[:opcode_bits] = {
          name: "opcode",
          msb: bit_counter,
          lsb: bit_counter - opcode_len + 1,
          value: nil
      }

      bit_counter - opcode_len
    end

    def field_size(field_name)
      field_hash = @fields.find { |f| f.key?(field_name) }
      raise "Unknown field: #{field_name}" unless field_hash
    
      size_str = field_hash[field_name]
    
      if size_str.start_with?('>=')
        size_str.gsub('>=', '').to_i
      else
        size_str.to_i
      end
    end

    def sum_operands_size(operands)
      operands.sum{ |op| field_size(op) }
    end

    def format_num_len
      num_formats = @instructions.size
      return 0 if num_formats <= 1

      Math.log2(num_formats).ceil # f_bits
    end

    def opcode_num_len(format)
      num_insns = format['insns'].size
      return 0 if num_insns <= 1

      Math.log2(num_insns).ceil # opcode_bits
    end
  end
end
