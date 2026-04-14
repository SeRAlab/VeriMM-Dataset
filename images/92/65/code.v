module top_module(in1,in2,func,out);input [0:31] in1;
input [0:31] in2;
input [0:5] func;
output reg [0:31] out;

always@(*)
    if(func == 6'b001000)
		out = in2;
	else
		out = in1;

endmodule