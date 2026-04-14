module top_module(PC_o,PCadd4);input [31:0] PC_o;

output [31:0] PCadd4;

assign PCadd4 = PC_o + 4;



endmodule