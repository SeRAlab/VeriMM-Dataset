module top_module(input[15:0] in1, input[15:0] in2, output wire[15:0] a, output wire[15:0] b);assign a=in1/in2;
	assign b=in1%in2;endmodule