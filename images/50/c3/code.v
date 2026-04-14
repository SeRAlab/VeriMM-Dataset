module top_module(input [15:0]imm_number,output [31:0]extended_number);assign extended_number = {{16{imm_number[15]}}, imm_number}; 
 endmodule