module top_module(selEAB1, PC, Ra, out);input selEAB1;
 input [15:0] PC, Ra;
 output [15:0] out;

 assign out = (selEAB1 == 1)? Ra: PC;endmodule