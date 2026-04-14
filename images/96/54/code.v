module top_module(out,in1,in2,sbit);input [15:0]in1,in2;
input sbit;
output [15:0] out;

assign out = (sbit==0)? in1:in2;

endmodule