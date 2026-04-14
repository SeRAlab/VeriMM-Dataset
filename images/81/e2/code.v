module top_module(ain,bin,select,out);input [15:0]ain,bin;
 input select;
 output [15:0] out;

 assign out=select?ain:bin;endmodule