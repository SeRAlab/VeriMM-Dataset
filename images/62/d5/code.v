module top_module( input         mem_to_reg,
                 input  [31:0] mem_out, alu_out,
                 output [31:0] write_data );assign write_data = mem_to_reg ? mem_out : alu_out;
      
endmodule