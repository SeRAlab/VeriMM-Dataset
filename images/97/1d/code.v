module top_module(
               input wire [31:0] instr_i,
               
               output wire       a,
               output wire       illegal_instr_o
               );wire                          b = ! instr_i[12:5];
   wire                          c = ! instr_i[1:0];
   wire                          d = ! instr_i[15:13];
   
   assign a = d ? b : 1'h1;
   assign illegal_instr_o = c ? a : 1'h0;
endmodule